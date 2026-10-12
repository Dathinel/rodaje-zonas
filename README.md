<p align="center">
  <a href="https://github.com/Dathinel/rodaje"><img src="https://raw.githubusercontent.com/Dathinel/rodaje/main/assets/marca/rodaje.svg" alt="Logotipo de Rodaje" width="104"></a>
</p>

<h1 align="center">rodaje-zonas</h1>

<p align="center">
  Complemento opcional para <a href="https://github.com/Dathinel/rodaje">Rodaje</a>: 12 guías de encuadre para el visor (recortes, tercios, centro, subtítulos y márgenes), calculadas a partir de las proporciones.
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/licencia-CC0_1.0-E8833A?style=flat-square&labelColor=1D1D1D" alt="Licencia CC0 1.0"></a>
  <a href="https://github.com/Dathinel/rodaje-zonas/releases/latest"><img src="https://img.shields.io/github/v/release/Dathinel/rodaje-zonas?style=flat-square&labelColor=1D1D1D&color=E8833A&label=versi%C3%B3n" alt="Última versión"></a>
  <img src="https://img.shields.io/badge/formato-.paquete-E8833A?style=flat-square&labelColor=1D1D1D" alt="Formato .paquete">
  <a href="https://github.com/Dathinel/rodaje"><img src="https://img.shields.io/badge/para-Rodaje-E8833A?style=flat-square&labelColor=1D1D1D" alt="Para Rodaje"></a>
</p>

| Guía | Pensada para | Qué marca |
|---|---|---|
| Cine 2,39:1 y 1,85:1 | 16:9 | El encuadre de cine y las bandas que se pierden |
| 4:3 en 16:9 | 16:9 | Lo que queda al recortar a 4:3 |
| Cuadrado y 4:5 en 16:9 | 16:9 | Recortes centrados para publicar en cuadrado o en 4:5 |
| Cuadrado, 4:5 y 16:9 en 9:16 | 9:16 | Lo mismo desde un vídeo vertical |
| Regla de los tercios | Cualquiera | Dos líneas verticales y dos horizontales |
| Centro | Cualquiera | La cruz del centro y un recuadro del 10 % |
| Zona de subtítulos | Cualquiera | La franja inferior para subtítulos |
| Margen de proyección 5 % | Cualquiera | Los bordes que pueden perderse al proyectar o imprimir |

Son guías genéricas, sin nombres ni interfaces de ninguna red: Rodaje ya trae de fábrica los márgenes EBU R 95 y las zonas de las apps más usadas. Las zonas sombreadas son lo que se pierde; las de línea discontinua, el encuadre que queda.

## Instalar en Rodaje

En Rodaje, Complementos → Instalar lo baja, comprueba su firma y lo instala. A mano: descarga `rodaje-zonas-<versión>.paquete` de las [releases](https://github.com/Dathinel/rodaje-zonas/releases) y, en Rodaje, usa «Instalar desde archivo…» en Complementos o suéltalo sobre la biblioteca. Aparecen en el botón de zonas seguras del visor.

## Construir el paquete

```
powershell -NoProfile -ExecutionPolicy Bypass -File empaquetar.ps1
```

Solo hace falta Windows PowerShell 5.1. Genera las zonas y deja `dist\rodaje-zonas-<versión>.paquete` con orden y fecha fijos: las mismas fuentes dan el mismo archivo byte a byte.

| Archivo | Qué es |
|---|---|
| `paquete.json` | Manifiesto: 12 `safe-zones` |
| `generar.ps1` | Calcula los recortes a partir de las proporciones; escribe `zonas/*.json` (`rodaje.safezones` v1) |
| `empaquetar.ps1` | Arma el `.paquete` |

## Licencia

CC0 1.0 (dominio público), ver `LICENSE`. El logotipo de Rodaje es marca de su autor y no forma parte de este contenido ([TRADEMARK.md](https://github.com/Dathinel/rodaje/blob/main/TRADEMARK.md)).
