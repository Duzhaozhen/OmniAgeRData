# ------------------------------------------------------------------------------
# OmniAgeRData: Data Generation Script
# ------------------------------------------------------------------------------
# This script documents the provenance and preprocessing of all datasets
# included in the OmniAgeRData package.

# --- 1. Original Data Sources (Biomarker Coefficients) ---
# Aging omic model coefficients were collected from various peer-reviewed
# studies, including:

# - cellular aging clocks (e.g., epiTOC2, DNAmTL)
# - chronological age clocks (e.g.,  Horvath 2013, Hannum 2013)
# - biological age clocks (e.g., PhenoAge, DunedinPACE, GrimAge2)
# - causal clocks (CausalAge, DamAge, AdaptAge)
# - stochastic clocks(StocH, StocP, StocZ)
# - cell-type specific clocks(e.g., Neu-In, Glia-In)
# - gestational age clocks(e.g., Bohlin 2016, Knight 2016)
# - surrogate biomarkers(e.g., CRP, IL6)
# - trait prediction (McCartney, 2018)
# - disease risk prediction(e.g.HepatoXuRisk)
# - cross species clocks(e.g., UniversalPanMammalianClocks)
# - transcriptomic clocks(e.g., scImmuAging)

# A full list of references for each clock is provided in the main
# OmniAgeR package documentation and the 'DataProvider' field
# of the metadata.csv file.

# --- 2. Example Datasets from GitHub Repositories ---

# CTSclocks Example: Extracted from
# https://github.com/HGT-UwU/CTSclocks/tree/main
# Original RData files were converted to RDS format.
# Files: CTS_ExampleData_Liver.rds, CTS_MurphyGSE88890.rds, CTS_PaiGSE112179.rds

# Gestational Age Example: From
# https://github.com/akknight/PredictGestationalAge
# Original CSV data converted to RDS format.
# File: GA_example.rds

# LungInv Example: From https://github.com/aet21/EpiMitClocks
# Original RData converted to RDS format.
# File: LungInv.rds

# --- 3. Example Datasets from CellXGene & Zenodo ---

# Single-cell filtered data from CellXGene (Gabitto 2024):
# Downloaded from
# https://datasets.cellxgene.cziscience.com/9d53f7bb-dc23-4c05-b2a6-
# 4afa9a6e3be0.rds
# File: seu_gabitto_2024_filtered.rds

# Yazar CD4T/CD8T data: From CellXGene (Yazar 2022).
# Downloaded from
# https://cellxgene.cziscience.com/collections/dde06e0f-ab3b-46be-96a2-
# a8082383c4a1
# Subset of 20 donors (CD4+ and CD8+ T cells) was selected as a placeholder.
# File: Yazar_CD4T_CD8T_example.rds

# Anage and Tursiops data: From Zenodo (Record 7574747).
# File: anage_data, Tursiops_example

# --- 4. Processed Datasets from Public Repositories (GEO/NODE) ---

# Hannum Example (GSE40279):
# 1. Raw IDAT files preprocessed using 'minfi' package.
# 2. Filtered probes with detection P-value >= 0.05.
# 3. Normalized via BMIQ method to correct for type-2 probe bias.
# 4. Randomly selected 50 samples for the final example dataset.
# File: Hannum_example.rds

# TZH_example_CTF (OEP000260):
# 1. Retrieved from https://www.biosino.org/node/project/detail/OEP000260.
# 2. Applied same preprocessing/normalization as Hannum_example.rds.
# 3. Estimated proportions of 12 immune cell types using 'EpiDISH'.
# 4. Randomly selected 50 samples for the final example dataset.
# File: TZH_example_CTF.rds
