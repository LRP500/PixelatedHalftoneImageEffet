using System.IO;
using UnityEngine;

public class ScreenCapture : MonoBehaviour
{
    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.F1))
        {
            Capture();
        }
    }

    private void Capture()
    {
        string folderPath = Directory.GetCurrentDirectory() + "/Screenshots/";

        if (!Directory.Exists(folderPath))
        {
            Directory.CreateDirectory(folderPath);
        }

        string screenshotName = "Capture_" + System.DateTime.Now.ToString("dd-MM-yyyy-HH-mm-ss") + ".png";

        UnityEngine.ScreenCapture.CaptureScreenshot(Path.Combine(folderPath, screenshotName));
    }
}
