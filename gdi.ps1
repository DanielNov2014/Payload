# Load WinForms and Drawing assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Add-Type @"
using System;
using System.Runtime.InteropServices;
public class GDI {
    [DllImport("user32.dll")]
    public static extern IntPtr GetDC(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern int ReleaseDC(IntPtr hWnd, IntPtr hDC);

    [DllImport("gdi32.dll")]
    public static extern bool BitBlt(IntPtr hdcDest, int xDest, int yDest, int wDest, int hDest,
                                     IntPtr hdcSrc, int xSrc, int ySrc, int rop);

    [DllImport("gdi32.dll")]
    public static extern IntPtr CreateCompatibleDC(IntPtr hdc);

    [DllImport("gdi32.dll")]
    public static extern IntPtr CreateCompatibleBitmap(IntPtr hdc, int nWidth, int nHeight);

    [DllImport("gdi32.dll")]
    public static extern IntPtr SelectObject(IntPtr hdc, IntPtr hgdiobj);

    [DllImport("gdi32.dll")]
    public static extern bool DeleteObject(IntPtr hObject);

    [DllImport("gdi32.dll")]
    public static extern bool DeleteDC(IntPtr hdc);
}
"@

Add-Type -AssemblyName System.Drawing

$screenW = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$screenH = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height

$angle = 0
$hueShift = 0

function Get-InvertMatrix($hue) {
    $rad = $hue * [Math]::PI / 180
    $rOffset = ([Math]::Sin($rad) + 1) / 2
    $gOffset = ([Math]::Sin($rad + 2*[Math]::PI/3) + 1) / 2
    $bOffset = ([Math]::Sin($rad + 4*[Math]::PI/3) + 1) / 2

    $m = New-Object Drawing.Imaging.ColorMatrix
    $m.Matrix00 = -1; $m.Matrix11 = -1; $m.Matrix22 = -1
    $m.Matrix33 = 1;  $m.Matrix44 = 1
    $m.Matrix40 = $rOffset
    $m.Matrix41 = $gOffset
    $m.Matrix42 = $bOffset
    return $m
}

$timer = New-Object Windows.Forms.Timer
$timer.Interval = 1
$timer.Add_Tick({
    # Get desktop DC
    $hdcDesktop = [GDI]::GetDC([IntPtr]::Zero)

    # Create compatible DC/bitmap
    $hdcMem = [GDI]::CreateCompatibleDC($hdcDesktop)
    $hBitmap = [GDI]::CreateCompatibleBitmap($hdcDesktop, $screenW, $screenH)
    [GDI]::SelectObject($hdcMem, $hBitmap)

    # Copy desktop into memory DC
    [GDI]::BitBlt($hdcMem, 0, 0, $screenW, $screenH, $hdcDesktop, 0, 0, 0x00CC0020) # SRCCOPY

    # Wrap in .NET Bitmap for processing
    $bmp = [System.Drawing.Bitmap]::FromHbitmap($hBitmap)

    # Invert + color cycle
    $mat = Get-InvertMatrix $hueShift
    $outBmp = New-Object Drawing.Bitmap $bmp.Width, $bmp.Height
    $g = [Drawing.Graphics]::FromImage($outBmp)
    $attr = New-Object Drawing.Imaging.ImageAttributes
    $attr.SetColorMatrix($mat)
    $g.DrawImage($bmp, [Drawing.Rectangle]::new(0,0,$bmp.Width,$bmp.Height), 0,0,$bmp.Width,$bmp.Height, [Drawing.GraphicsUnit]::Pixel, $attr)
    $g.Dispose()
    $bmp.Dispose()

    # Rotate
    $rotBmp = New-Object Drawing.Bitmap $outBmp.Width, $outBmp.Height
    $g2 = [Drawing.Graphics]::FromImage($rotBmp)
    $g2.TranslateTransform($outBmp.Width/2, $outBmp.Height/2)
    $g2.RotateTransform($angle)
    $g2.TranslateTransform(-$outBmp.Width/2, -$outBmp.Height/2)
    $g2.DrawImage($outBmp, 0, 0)
    $g2.Dispose()
    $outBmp.Dispose()

    # Draw back to desktop
    $g3 = [Drawing.Graphics]::FromHdc($hdcDesktop)
    $g3.DrawImage($rotBmp, 0, 0)
    $g3.Dispose()
    $rotBmp.Dispose()

    # Cleanup
    [GDI]::DeleteObject($hBitmap)
    [GDI]::DeleteDC($hdcMem)
    [GDI]::ReleaseDC([IntPtr]::Zero, $hdcDesktop)

    # Advance
    $angle = ($angle + 5) % 360
    $hueShift = ($hueShift + 10) % 360
})
$timer.Start()

[Windows.Forms.Application]::Run((New-Object Windows.Forms.Form))
