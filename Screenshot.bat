@echo off
powershell -ExecutionPolicy Bypass -Command "& {Add-Type -TypeDefinition @'
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Windows.Forms;
public class Screenshot {
    public static void CaptureScreen(string filename) {
        Bitmap bitmap = new Bitmap(Screen.PrimaryScreen.Bounds.Width, Screen.PrimaryScreen.Bounds.Height);
        Graphics graphics = Graphics.FromImage(bitmap);
        graphics.CopyFromScreen(0, 0, 0, 0, bitmap.Size);
        bitmap.Save(filename, ImageFormat.Png);
    }
}
'@ -Language CSharp; [Screenshot]::CaptureScreen('./')}"
