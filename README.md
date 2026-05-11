# Replication Package: Right-wing terrorism and far-right support: Evidence from anti-Roma attacks in Hungary

This repository contains the replication code for:

**Simonovits, Gáspár, Békés, Végh (2025): Right-wing terrorism and far-right support: Evidence from anti-Roma attacks in Hungary**

## System Requirements

The replication code was tested on:
- **Stata**: MP 18.0 or higher
- **Operating System**: Windows 11 Pro (Build number 26200.7462)
- **Hardware**: 12th Gen Intel(R) Core(TM) i5-12450H (2.00 GHz), 32 GB RAM

## Required Stata Packages

Before running the replication, install the following packages:
```stata
ssc install synth 
ssc install spmap 
ssc install maptile
ssc install sensemakr
```

## File Structure

### Main Scripts
- `do_everything.do` - Master script that runs the entire replication
- `replication_log.txt` - Log file generated during replication

### Data Processing Scripts
- `append_elections_from_raw_data_files.do` - Processes election panel data
- `create_treatment_var.do` - Generates treatment variables
- `kuruc_generator.do` - Generates far-right portal mentions (**WARNING: VERY SLOW**)
- `merge_data_sources.do` - Creates the main analysis dataset
- `synth_control_generation.do` - Generates synthetic control units
- `synth_append.do` - Combines synthetic units for regression analysis
- `synthetic_units_table.do` - Creates donor pool descriptive statistics

### Analysis Scripts

#### Main Tables
- `balance.do` - Generates balance tables (Table OA3)
- `exhibits.do` - Main regression results (Table 1, Tables OA4-OA5)
- `exhibits_alternative_outcomes.do` - Alternative outcome specifications (Tables OA8-OA10)
- `exhibits_demography.do` - Additional demographic controls (Table OA11)
- `regressions_sensemakr.do` - Robustness analysis using Cinelli & Hazlett (2020) method

#### Main Figures
- `event_study.do` - Event study analysis (Figure 1, Table OA6)
- `spatial_decay_figure.do` - Spatial decay analysis (Figure 2, Table OA7)
- `election_survey_evidence.do` - Survey evidence (Figures OA1-OA2)
- `map_generation.do` - Geographic visualization (Figure OA4)
- `partysupport_comparison_figure.do` - Cross-country comparison (Figure OA3)

### Utility Scripts
- `scraping/` - Directory containing web scraping scripts for kuruc.info data

## Data Requirements

The replication code expects the following data directories (relative to the code folder):

- `../replication_data/` - Working directory for processed data
- `../data/election/` - Raw election data
- `../data/distances/` - Settlement distance data
- `../data/` - Census Roma share data
- `../data/tstar/` - Settlement control data
- `../data/kuruc/` - Scraped kuruc.info posts
- `../data/survey2009/` - Social attitudes survey data
- `../data/map/` - Geographic map data
- `../data/parlgov/` - Political party data
- `../data/unemp/` - Monthly unemployment data

## Output Structure

Results are saved to:
- `../replication_evidence/` - Tables and figures

## How to Run

1. **Set working directory**: Edit line 21 in `do_everything.do` to point to your code folder location
2. **Install required packages** (see above)
3. **Ensure data availability**: Make sure all required data directories are available
4. **Run master script**:
   ```stata
   do do_everything.do
   ```

## Generated Output

### Main Tables
- **Table 1**: Main regression results
- **Table OA2**: Synthetic control weights
- **Table OA3**: Balance table
- **Table OA4**: DiD with control variable coefficients
- **Table OA5**: DiD pre-trends
- **Table OA6**: Event study regression results
- **Table OA7**: Spatial decay regression results
- **Tables OA8-OA10**: Alternative outcomes (turnout, vote shares)
- **Table OA11**: Additional demographic controls

### Main Figures
- **Figure 1**: Event study
- **Figure 2**: Far-right support and distance from attacks
- **Figure OA1**: Favorability of ethnic groups
- **Figure OA2**: Statements about the Roma
- **Figure OA3**: Far-right support in selected countries
- **Figure OA4**: Map of attacked, control, and donor pool settlements
- **Figure OA5**: Synthetic control effect sizes
- **Figure OA6**: Synthetic control individual treatment effects

## Notes

- Scraping scripts in Python for the far-right kuruc.info portal are in the **scraping** folder. 

## Contact

For questions about the replication code, please contact the authors.

---

*Last updated: January 2026*