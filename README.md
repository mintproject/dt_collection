# Data Transformations for MINT

This repository contains a collection of workflows (CWL) to run Data Transformation implemented by [MINT DataTransformation](https://github.com/mintproject/MINT-Transformation)

## Collection

There two ways to run the Data Transformation:
- DataCatalog: Using files registered in the DataCatalog.
- Local files: Using files in your computer or hosted in a public site.

The DataTransformations available are:

| Name             | Description | DataCatalog | Localfiles |
|------------------|-------------|-------------|------------|
| topoflow_climate |             | Working | Working    |

## How to add new Data Transformation. 

1. Copy the `.template` directory with a new name
2. Edit the file `datacatalog/dt.cwl`.  
    1. You must edit the MINT Data Transformation configuration file (line 13) according the new Data Transformation.
    2. Add or remove inputs (line 75)
3. Run it `cwltool --no-match-user --no-read-only workflow.cwl values.yml`
