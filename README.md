# E-Commerce Operations Demand Forecasting Analysis

## Overview

This repository contains a demand forecasting analysis for a mid-size e‑commerce business.  
The goal is to build, evaluate, and interpret forecasting models to support operational decisions in customer care, inventory, and fulfillment.  

The main analysis is implemented in Python notebooks, supported by SQL scripts for data exploration or transformation.

---

## Repository Structure

- README.md # Main project documentation (this file)
- requirements.txt # Python dependencies
- analysis # Executive Summary of the project
- data/ # Input data (caught in .gitignore)
- notbooks/ # Jupyter Notebook file with model built
- sql/ # SQL scripts (3 files)
- results/ # Exported csv forecasts and model performance table
    - visualizations/ # Plots used in reports

- The detailed project narrative and technical discussion live in `analysis/executive_summary.md`. 
- This top-level README focuses on setup, usage, and assumptions.

---

## Environment Setup

### 1. Prerequisites

- Python **3.11** (or 3.10+)
- Git
- A virtual environment tool such as `venv` or `conda`
- Access to a SQL database (if you want to execute the SQL files)

### 2. Clone the Repository

git clone https://github.com/traha-89/yepoda_ops_casestudy.git
cd yepoda_ops_casestudy

### 3. Create and Activate a Virtual Environment

Using `venv`:
python -m venv .venv
source .venv/bin/activate # On macOS/Linux

or
..venv\Scripts\activate # On Windows

## Dependencies and Installation

All Python dependencies can be managed via `requirements.txt`.  
Typical packages used in this project include:

- `numpy`
- `pandas`
- `scipy`
- `matplotlib`
- `seaborn`
- `statsmodels`
- `statsforecast`
- `utilsforecast`
- `pmdarima`
- `prophet` (or `cmdstan` backend as required)
- `jupyter` / `jupyterlab`

Install dependencies:

pip install -r requirements.txt

## How to Run the Notebooks

1. Activate your virtual environment (see above).  
2. From the repository root, start Jupyter.
3. In the Jupyter interface, navigate to: analysis/
4. Open the main notebook:
    analysis/demand_forecasting_analysis.ipynb
5. Run all cells from top to bottom to.

## How to Run the SQL Files

There are **3 SQL files** stored in the `sql/` directory:
sql/
- 01_schema_setup.sql
- 02_data_quality.sql
- 03_exploratory_analysis.sql

These scripts are designed to be run against your analytical database (e.g. I have used MYSQL).  

### Using a SQL Client

1. Open MySQL client
2. Connect to your target database.  
3. Open the desired `.sql` file from the `sql/` folder.  
4. Execute the script in your client.

## Core Python Imports

The main notebook relies on the following imports:
**Paths and core libs**  
- from pathlib import Path
- import os
- import numpy as np
- import pandas as pd
- import datetime as dt
- from pandas.tseries.offsets import DateOffset
- from scipy import stats
- import warnings
- warnings.filterwarnings('ignore')

**Display config**  
- pd.set_option('display.max_columns', None)

**Visualization**
- import matplotlib.pyplot as plt
- import seaborn as sns
- from utilsforecast.plotting import plot_series

**Forecasting**
- from statsforecast import StatsForecast
- from statsforecast.models import SeasonalNaive, AutoARIMA
- import pmdarima as pm
- from functools import partial
- from prophet import Prophet
- from prophet.plot import add_changepoints_to_plot
- from prophet.diagnostics import cross_validation, performance_metrics

**Forecast evaluation**
- from statsmodels.tsa.seasonal import seasonal_decompose
- from utilsforecast.evaluation import evaluate
- from utilsforecast.losses import mae, mse, rmse, mape, smape, mase, scaled_crps

If any import fails, confirm that the corresponding library is listed in `requirements.txt` and reinstall.

## Assumptions

This project makes a few key assumptions:

- **Synthetic data**: The `daily_demand.csv` file is synthetic and does not represent any real company; it is safe to commit and share.  
- **Single time zone**: All dates and timestamps are treated as a single time zone with no daylight saving adjustments.  
- **Stable process**: Historical patterns (seasonality, holiday effects, promotion impacts) are assumed to be broadly stable over the forecast horizon.  
- **SQL environment**: The provided SQL scripts are examples and may require adjustment (schema names, database dialect) to run on your specific database.  

---

## Contact / Contribution

- For questions or feedback, please open an issue in this repository.  
- Contributions (bug fixes, additional models, or improved visualizations) are welcome via pull requests.
