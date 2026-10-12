# Genera las zonas de rodaje-zonas (rodaje.safezones v1) en <Destino>\zonas\, deterministas: la misma salida byte a
# byte en cualquier equipo. Lo llama empaquetar.ps1; sin -Destino escribe en la carpeta del script.
# Son guías genéricas de encuadre (recortes de cine, de redes y de 4:3, tercios, subtítulos, márgenes), calculadas
# a partir de las proporciones: rect = [x, y, ancho, alto] en fracciones de la imagen, redondeadas a 4 decimales.
param([string]$Destino = '')

$ErrorActionPreference = 'Stop'
$inv = [System.Globalization.CultureInfo]::InvariantCulture

function Redondo([double]$x) { [Math]::Round($x, 4) }
function Zona([string]$etiqueta, [string]$tipo, [double]$x, [double]$y, [double]$w, [double]$h) {
    [ordered]@{ label = $etiqueta; kind = $tipo; rect = @((Redondo $x), (Redondo $y), (Redondo $w), (Redondo $h)) }
}

function Juego([string]$id, [string]$nombre, [string]$descripcion, $aspecto, [bool]$centro, $zonas) {
    $j = [ordered]@{ format = 'rodaje.safezones'; version = 1; id = $id; name = $nombre; description = $descripcion }
    if ($aspecto) { $j.aspect = [ordered]@{ width = $aspecto[0]; height = $aspecto[1] } }
    if ($centro) { $j.center = $true }
    $j.zones = @($zonas)
    $j
}

# Recorte centrado de proporción rw:rh dentro de un lienzo lw:lh: el marco que queda (safe) y lo que se pierde (interface).
function Recorte([double]$lw, [double]$lh, [double]$rw, [double]$rh, [string]$marco) {
    $lienzo = $lw / $lh
    $recorte = $rw / $rh
    if ($recorte -ge $lienzo) {
        $alto = Redondo ($lienzo / $recorte)
        $y = Redondo ((1 - $alto) / 2)
        @((Zona $marco 'safe' 0 $y 1 $alto), (Zona 'Fuera del recorte' 'interface' 0 0 1 $y), (Zona 'Fuera del recorte' 'interface' 0 ($y + $alto) 1 (1 - $y - $alto)))
    } else {
        $ancho = Redondo ($recorte / $lienzo)
        $x = Redondo ((1 - $ancho) / 2)
        @((Zona $marco 'safe' $x 0 $ancho 1), (Zona 'Fuera del recorte' 'interface' 0 0 $x 1), (Zona 'Fuera del recorte' 'interface' ($x + $ancho) 0 (1 - $x - $ancho) 1))
    }
}

$linea = 0.002
$juegos = @(
    (Juego 'cine-239' 'Cine 2,39:1' 'Encuadre panorámico de cine (2,39:1) dentro de 16:9: lo que queda fuera se pierde con bandas negras.' @(16, 9) $false `
        (Recorte 16 9 2.39 1 'Encuadre 2,39:1')),
    (Juego 'cine-185' 'Cine 1,85:1' 'Encuadre de cine (1,85:1) dentro de 16:9.' @(16, 9) $false `
        (Recorte 16 9 1.85 1 'Encuadre 1,85:1')),
    (Juego 'cuatro-tercios' '4:3 en 16:9' 'Lo que se ve si la imagen 16:9 se recorta a 4:3.' @(16, 9) $false `
        (Recorte 16 9 4 3 'Encuadre 4:3')),
    (Juego 'cuadrado-en-horizontal' 'Cuadrado en 16:9' 'Recorte cuadrado (1:1) centrado en una imagen 16:9.' @(16, 9) $false `
        (Recorte 16 9 1 1 'Encuadre 1:1')),
    (Juego 'cuatro-quintos-en-horizontal' '4:5 en 16:9' 'Recorte vertical 4:5 centrado en una imagen 16:9.' @(16, 9) $false `
        (Recorte 16 9 4 5 'Encuadre 4:5')),
    (Juego 'cuadrado-en-vertical' 'Cuadrado en 9:16' 'Recorte cuadrado (1:1) centrado en una imagen vertical 9:16.' @(9, 16) $false `
        (Recorte 9 16 1 1 'Encuadre 1:1')),
    (Juego 'cuatro-quintos-en-vertical' '4:5 en 9:16' 'Recorte 4:5 centrado en una imagen vertical 9:16.' @(9, 16) $false `
        (Recorte 9 16 4 5 'Encuadre 4:5')),
    (Juego 'horizontal-en-vertical' '16:9 en 9:16' 'La franja 16:9 que cabe en una imagen vertical 9:16.' @(9, 16) $false `
        (Recorte 9 16 16 9 'Encuadre 16:9')),
    (Juego 'tercios' 'Regla de los tercios' 'Dos líneas verticales y dos horizontales que dividen la imagen en tercios.' $null $false @(
        (Zona 'Tercio vertical' 'safe' (1 / 3 - $linea / 2) 0 $linea 1),
        (Zona 'Tercio vertical' 'safe' (2 / 3 - $linea / 2) 0 $linea 1),
        (Zona 'Tercio horizontal' 'safe' 0 (1 / 3 - $linea / 2) 1 $linea),
        (Zona 'Tercio horizontal' 'safe' 0 (2 / 3 - $linea / 2) 1 $linea))),
    (Juego 'centro' 'Centro' 'La cruz del centro y un recuadro del 10 % alrededor.' $null $true @(
        (Zona 'Centro' 'safe' 0.45 0.45 0.1 0.1))),
    (Juego 'subtitulos' 'Zona de subtítulos' 'Franja inferior donde van los subtítulos, dentro del margen de títulos.' $null $false @(
        (Zona 'Subtítulos' 'safe' 0.1 0.76 0.8 0.16))),
    (Juego 'margen-proyeccion' 'Margen de proyección 5 %' 'Bordes del 5 % que pueden quedar fuera al proyectar o imprimir.' $null $false @(
        (Zona 'Margen 5 %' 'interface' 0 0 1 0.05),
        (Zona 'Margen 5 %' 'interface' 0 0.95 1 0.05),
        (Zona 'Margen 5 %' 'interface' 0 0.05 0.05 0.9),
        (Zona 'Margen 5 %' 'interface' 0.95 0.05 0.05 0.9)))
)

function Json($v, [string]$sangria = '') {
    $mas = $sangria + '  '
    if ($null -eq $v) { return 'null' }
    if ($v -is [bool]) { if ($v) { return 'true' } else { return 'false' } }
    if ($v -is [string]) { return '"' + $v.Replace('\', '\\').Replace('"', '\"') + '"' }
    if ($v -is [int] -or $v -is [long] -or $v -is [double] -or $v -is [decimal]) { return ([double]$v).ToString('R', $inv) }
    if ($v -is [System.Collections.IDictionary]) {
        $partes = foreach ($k in $v.Keys) { $mas + '"' + $k + '": ' + (Json $v[$k] $mas) }
        return "{`n" + ($partes -join ",`n") + "`n$sangria}"
    }
    if ($v -is [System.Collections.IEnumerable]) {
        $lista = @($v)
        if ($lista.Count -eq 0) { return '[]' }
        $simples = -not ($lista | Where-Object { $_ -is [System.Collections.IDictionary] })
        if ($simples) { return '[' + (($lista | ForEach-Object { Json $_ $mas }) -join ', ') + ']' }
        $partes = foreach ($x in $lista) { $mas + (Json $x $mas) }
        return "[`n" + ($partes -join ",`n") + "`n$sangria]"
    }
    throw "Tipo sin JSON: $($v.GetType().FullName)"
}

if (-not $Destino) { $Destino = $PSScriptRoot }
$carpeta = Join-Path ([System.IO.Path]::GetFullPath($Destino)) 'zonas'
[System.IO.Directory]::CreateDirectory($carpeta) | Out-Null
$utf8 = New-Object System.Text.UTF8Encoding($false)
foreach ($j in $juegos) {
    [System.IO.File]::WriteAllText((Join-Path $carpeta "$($j.id).json"), (Json $j) + "`n", $utf8)
}
Write-Host "  $($juegos.Count) juegos de zonas en $carpeta"
