# synergr: Drug Synergy Analysis

A toolkit for quantifying and visualising drug combination synergy using the **Loewe additivity model**. Fits four-parameter log-logistic (4PL) dose-response curves to single-agent data, computes Combination Index (CI) values for every combination point, and renders the results as a heatmap, normalised isobologram, or interactive 3D surface.

---

## Installation

Install directly from GitHub using devtools. All dependencies are declared in the package `DESCRIPTION` and will be installed automatically.

```r
# install.packages("devtools")
devtools::install_github("https://github.com/SeanTattan/synergr")
```
---

## Core Workflow

```r
result <- analyse_synergy(
  data    = my_data,
  drug_a  = compound_conc,
  drug_b  = inhibitor_conc,
  response = viability
)

print(result)
plot_heatmap(result)
plot_isobologram(result)
plot_surface(result)
```

---

## Functions

### `analyse_synergy()`

Fits 4PL models to single-agent arms and calculates Loewe CI values for all combination points.

```r
analyse_synergy(data, drug_a, drug_b, response)
```

| Argument   | Type        | Description                                                   |
|------------|-------------|---------------------------------------------------------------|
| `data`     | data frame  | Input data containing dose and response columns               |
| `drug_a`   | unquoted col | Column of Drug A concentrations                              |
| `drug_b`   | unquoted col | Column of Drug B concentrations                              |
| `response` | unquoted col | Column of response values (e.g. % viability, inhibition)     |

**Returns** a `synergy_result` S3 object containing:

| Slot       | Description                                              |
|------------|----------------------------------------------------------|
| `$data`    | Cleaned data frame with columns `DrugA`, `DrugB`, `Response` |
| `$ci_data` | Combination points augmented with `Dx_A`, `Dx_B`, and `CI` |
| `$models`  | Named list `A` / `B` of `drc::drm` 4PL fit objects      |

> Response values are floored at 0 before fitting.

---

### `plot_heatmap()`

Renders a tile heatmap of Combination Index values across the dose matrix. Colour is centred at CI = 1 (additivity).

```r
plot_heatmap(x, ...)
```

| Argument | Type             | Description                          |
|----------|------------------|--------------------------------------|
| `x`      | `synergy_result` | Object returned by `analyse_synergy()` |
| `...`    | —                | Unused                               |

**Returns** a `ggplot2` object.

---

### `plot_isobologram()`

Generates a **normalised isobologram** — each combination point is plotted as its fraction of the single-agent equieffective dose, coloured by CI.

```r
plot_isobologram(result, save = FALSE, width = 7, height = 6, dpi = 300)
```

| Argument | Type             | Default | Description                                          |
|----------|------------------|---------|------------------------------------------------------|
| `result` | `synergy_result` | —       | Object returned by `analyse_synergy()`               |
| `save`   | logical          | `FALSE` | If `TRUE`, saves PNG to `figures/isobologram.png`    |
| `width`  | numeric          | `7`     | Plot width in inches                                 |
| `height` | numeric          | `6`     | Plot height in inches                                |
| `dpi`    | numeric          | `300`   | Resolution                                           |

**Returns** a `ggplot2` object (invisibly when `save = TRUE`).

**Colour scale:**

| Colour | Meaning      | CI     |
|--------|--------------|--------|
| Red    | Synergy      | < 1    |
| White  | Additivity   | = 1    |
| Blue   | Antagonism   | > 1    |

```r
# Basic plot
plot_isobologram(result)

# Save to file
plot_isobologram(result, save = TRUE, dpi = 600)
```

---

### `plot_surface()`

Renders an interactive **3D response surface** via `plotly`, with surface colour mapped to CI.

```r
plot_surface(x, ...)
```

| Argument | Type             | Description                          |
|----------|------------------|--------------------------------------|
| `x`      | `synergy_result` | Object returned by `analyse_synergy()` |
| `...`    | —                | Unused                               |

**Returns** a `plotly` object.

> Requires combination data to form a regular grid; sparse or irregular designs may produce gaps in the surface.

---

## Data Format

Input data must contain at least three columns — one per drug concentration and one for the response. Single-agent rows (where one drug is 0) are required for model fitting.

```
DrugA   DrugB   Response
0       0       100
1       0        82
10      0        45
100     0         9
0       1        90
0       10       55
0       100      11
1       1        70
10      10       20
...
```

---

## Combination Index Interpretation

The **Loewe CI** is defined as:

$$CI = \frac{d_A}{Dx_A} + \frac{d_B}{Dx_B}$$

where $d_A$ and $d_B$ are the doses used in the combination, and $Dx_A$, $Dx_B$ are the single-agent doses that produce the same effect.

| CI     | Interpretation |
|--------|----------------|
| < 1    | Synergy        |
| = 1    | Additivity     |
| > 1    | Antagonism     |

