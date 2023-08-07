package com.example.opencv_test

import android.content.Context
import android.graphics.Bitmap
import com.google.android.gms.tasks.Task
import com.google.android.gms.tasks.Tasks
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.text.Text
import com.google.mlkit.vision.text.TextRecognition
import com.google.mlkit.vision.text.TextRecognizer
import com.google.mlkit.vision.text.korean.KoreanTextRecognizerOptions
import io.flutter.plugin.common.MethodChannel
import org.opencv.android.Utils
import org.opencv.core.Core
import org.opencv.core.CvType
import org.opencv.core.Mat
import org.opencv.core.MatOfPoint
import org.opencv.core.MatOfPoint2f
import org.opencv.core.Point
import org.opencv.core.Rect
import org.opencv.core.Size
import org.opencv.imgproc.Imgproc
import java.io.ByteArrayOutputStream
import java.util.concurrent.ExecutionException

class ScanCardResult(private val data: ByteArray, private val imageWidth: Int, private val imageHeight: Int, result: MethodChannel.Result, context: Context) : Thread() {
    private val context: Context? = null
    private val result: MethodChannel.Result
    var resizeImage: Point
    var dataPath = ""
    var recognizer: TextRecognizer = TextRecognition.getClient(KoreanTextRecognizerOptions.Builder().build())

    init {
        this.result = result
        resizeImage = Point(600.0, 450.0)
    }

    override fun run() {
        super.run()
        result.success(scanCardResult(data, imageWidth, imageHeight))
    }

    private fun scanCardResult(data: ByteArray, imageWidth: Int, imageHeight: Int): Map<String, Any> {
        var lineList = mutableListOf<List<Double>>()
        var outputMap = mutableMapOf<String, Any>()
        val inputMat = Mat(imageWidth, imageHeight, CvType.CV_8UC1)
        inputMat.put(0, 0, data)
        val srcMat = Mat(imageHeight, imageWidth, CvType.CV_8UC1)
        Core.rotate(inputMat, srcMat, Core.ROTATE_90_CLOCKWISE)
        val originMat: Mat = srcMat.clone()
        Imgproc.GaussianBlur(srcMat, srcMat, Size(5.0, 5.0), 0.0)
        Imgproc.Canny(srcMat, srcMat, 50.0, 100.0)
        val tempThreshold: Double = Imgproc.threshold(srcMat, srcMat, 0.0, 255.0, Imgproc.THRESH_BINARY + Imgproc.THRESH_OTSU)
        val hierarchy = Mat()
        var contours = mutableListOf<MatOfPoint>()
        Imgproc.findContours(srcMat, contours, hierarchy, Imgproc.RETR_LIST, Imgproc.CHAIN_APPROX_SIMPLE)

        var maxArea = 0.0
        var document_contour = MatOfPoint2f()
        for (contour in contours) {
            val area: Double = Imgproc.contourArea(contour)
            if (area > 30000) {
                val peri: Double = Imgproc.arcLength(MatOfPoint2f(*contour.toArray()), true)
                val approx = MatOfPoint2f()
                Imgproc.approxPolyDP(MatOfPoint2f(*contour.toArray()), approx, 0.015 * peri, true)
                if (area > maxArea && approx.toList().size === 4) {
                    document_contour = approx
                    maxArea = area
                }
            }
        }
        if (maxArea < 1) return outputMap
        val points: List<Point> = document_contour.toList()
        var tl = Point(Double.MAX_VALUE, Double.MAX_VALUE)
        var br = Point(0.0, 0.0)
        for (point in points) {
            lineList.add(toList(point))
            if (tl.x >= point.x && tl.y >= point.y) {
                tl = point
            } else if (br.x <= point.x && br.y <= point.y) {
                br = point
            }
        }

        /*output.add(toList(tl));
        output.add(toList(br));
        output.add(toList(new Point(originMat.rows(), originMat.cols())));*/
        var subMat: Mat? = null
        val rect = Rect(tl, br)
        if (!lineList.isEmpty()) {
            subMat = originMat.submat(rect)
            //output.add(toList(new Point(subMat.cols(), subMat.rows())));
            val image: InputImage = InputImage.fromBitmap(matToBitmap(subMat), 0)
            val result: Task<Text> = recognizer.process(image)
            try {
                Tasks.await(result)
            } catch (e: ExecutionException) {
                throw RuntimeException(e)
            } catch (e: InterruptedException) {
                throw RuntimeException(e)
            }
            outputMap.put("string", result.getResult().getText())
            //
//            String OCRresult = tessBaseAPI.getUTF8Text();
//            outputMap.put("tesseract", OCRresult);
        }
        outputMap.put("lineList", lineList)
        outputMap.put("width", resizeImage.x)
        outputMap.put("height", resizeImage.y)

        return outputMap
    }

    private fun matToBytes(mat: Mat): ByteArray {
        val image: Bitmap = Bitmap.createBitmap(mat.cols(),
                mat.rows(), Bitmap.Config.ARGB_8888)
        Utils.matToBitmap(mat, image)
        var bitmap: Bitmap = image as Bitmap
        bitmap = Bitmap.createScaledBitmap(bitmap, resizeImage.x as Int, resizeImage.y as Int, false)
        val byteArrayOutputStream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, byteArrayOutputStream)
        return byteArrayOutputStream.toByteArray()
    }

    private fun matToBitmap(mat: Mat): Bitmap {
        var image: Bitmap = Bitmap.createBitmap(mat.cols(),
                mat.rows(), Bitmap.Config.ARGB_8888)
        Utils.matToBitmap(mat, image)
        image = Bitmap.createScaledBitmap(image, resizeImage.x as Int, resizeImage.y as Int, false)
        return image
    }

    private fun toList(p: Point): List<Double> {
        var output = mutableListOf<Double>()
        output.add(p.x)
        output.add(p.y)
        return output
    }

    private fun distance(p1: Point, p2: Point): Double {
        val yd: Double = Math.pow(p1.y - p2.y, 2.0)
        val xd: Double = Math.pow(p1.x - p2.x, 2.0)
        return Math.sqrt(yd + xd)
    }
}