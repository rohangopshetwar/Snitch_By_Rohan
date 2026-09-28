# Generic fix script for saved Next.js Snitch pages
# Usage: .\fix_nextjs_page.ps1 "page_name"
param([string]$PageName = "Buy Trousers for men online in India")

$basePath = "C:\Users\gopsh\OneDrive\Desktop\Demo_guide\Snitch_By_Rohan\by_me"
$filePath = Join-Path $basePath "$PageName.html"
$cssPath = Join-Path $basePath "${PageName}_files\d35a891f3c4a4a09.css"

if (-not (Test-Path $filePath)) {
    Write-Host "File not found: $filePath" -ForegroundColor Red
    exit 1
}

Write-Host "Fixing: $filePath" -ForegroundColor Yellow

$content = [System.IO.File]::ReadAllText($filePath)

# 1. Remove data-precedence="next" (prevents CSS loading)
$content = $content -replace 'data-precedence="next"', ''

# 2. Remove Next.js hydration scripts (cause blank screen)
$content = [regex]::Replace($content, '<script>self\.__next_f\.push\([^<]*\)</script>', '')
$content = [regex]::Replace($content, '<script>\(self\.__next_f=self\.__next_f\|\|\[\]\)\.push\(\[0\]\);self\.__next_f\.push\(\[2,null\]\)</script>', '')

# 3. Remove Next.js route announcer
$content = [regex]::Replace($content, '<next-route-announcer[^>]*>.*?</next-route-announcer>', '')

# 4. Fix font paths
$content = $content -replace 'url\(/_next/static/media/', 'url(https://www.snitch.com/_next/static/media/'

# 5. Remove .js.download scripts
$content = [regex]::Replace($content, '<script src="[^"]*\.js\.download"[^>]*></script>', '')
$content = [regex]::Replace($content, '<link rel="preload" as="script" fetchpriority="low" href="[^"]*\.js\.download">', '')

# 6. Remove tracking scripts
$content = [regex]::Replace($content, '<script[^>]*src="[^"]*fbevents\.js\.download"[^>]*></script>', '')
$content = [regex]::Replace($content, '<script[^>]*src="[^"]*gtm\.js\.download"[^>]*></script>', '')

# 7. Remove inline GTM/GA/FB scripts
$content = [regex]::Replace($content, '<script id="_next-gtm-init"[^>]*>[\s\S]*?</script>', '')
$content = [regex]::Replace($content, '<script[^>]*id="_next-gtm"[^>]*></script>', '')
$content = [regex]::Replace($content, '<script id="_next-ga-init"[^>]*>[\s\S]*?</script>', '')
$content = [regex]::Replace($content, '<script[^>]*id="_next-ga"[^>]*></script>', '')
$content = [regex]::Replace($content, '<script id="facebook-pixel"[^>]*>[\s\S]*?</script>', '')

# 8. Remove tracker scripts
$content = [regex]::Replace($content, '<script[^>]*src="[^"]*f\(\d+\)\.txt"[^>]*></script>', '')
$content = [regex]::Replace($content, '<script[^>]*src="[^"]*f\.txt"[^>]*></script>', '')
$content = [regex]::Replace($content, '<script[^>]*src="[^"]*1635115906661725"[^>]*></script>', '')
$content = [regex]::Replace($content, '<script[^>]*class="ct-jp-cb"[^>]*></script>', '')

# 9. Remove remaining inline tracking scripts
$content = [regex]::Replace($content, '<script type="text/javascript" id="" charset="">!function\(b,e,f,g,a,c,d\).*?</script>', '')
$content = [regex]::Replace($content, '<script id="" text="" charset="" type="text/javascript"[^>]*></script>', '')
$content = [regex]::Replace($content, '<script type="text/javascript" id="" charset="">window\.dataLayer.*?</script>', '')

# 10. Remove broken preload links
$content = [regex]::Replace($content, '<link rel="preload" href="[^"]*\.js\.download" as="script">', '')
$content = [regex]::Replace($content, '<link rel="preload" href="[^"]*js\(1\)" as="script">', '')
$content = [regex]::Replace($content, '<link rel="preconnect" href="https://www\.snitch\.com/fonts"[^>]*>', '')
$content = [regex]::Replace($content, '<link rel="preload" href="https://www\.snitch\.com/fonts/[^"]*"[^>]*>', '')
$content = [regex]::Replace($content, '<link rel="preload" as="image" href="https://www\.facebook\.com[^"]*">', '')
$content = [regex]::Replace($content, '<link rel="preload" as="image" href="https://cdn\.shopify\.com[^"]*">', '')
$content = [regex]::Replace($content, '<link rel="preload" as="image" href="https://d2d5n4ft74bagm[^"]*">', '')
$content = [regex]::Replace($content, '<link rel="preload" href="https://cdn\.shopify\.com[^"]*" as="image"[^>]*>', '')
$content = [regex]::Replace($content, '<link rel="preload" href="https://www\.snitch\.com/_next/static/media/[^"]*" as="font"[^>]*>', '')
$content = [regex]::Replace($content, '<link rel="preload" as="style" href="[^"]*">', '')

[System.IO.File]::WriteAllText($filePath, $content)

# Fix the font CSS file too
if (Test-Path $cssPath) {
    $css = [System.IO.File]::ReadAllText($cssPath)
    $css = $css -replace 'url\(/_next/static/media/', 'url(https://www.snitch.com/_next/static/media/'
    [System.IO.File]::WriteAllText($cssPath, $css)
    Write-Host "  Fixed font CSS: $cssPath" -ForegroundColor Green
}

Write-Host "Done! Page fixed." -ForegroundColor Green
