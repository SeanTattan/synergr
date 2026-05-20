# synergr

Reusable R package for drug synergy analysis using Loewe Combination Index methodology.

## Installation

```r
devtools::install_local("synergr")
```

## Example

```r
library(synergr)

result <- analyse_synergy(
  data = df,
  drug_a = compound_conc,
  drug_b = inhibitor_conc,
  response = value
)

plot_surface(result)
plot_heatmap(result)
```
