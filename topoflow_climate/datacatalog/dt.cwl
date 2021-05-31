#!/usr/bin/env cwl-runner

cwlVersion: v1.1 
class: CommandLineTool
hints:
  DockerRequirement:
    dockerImageId: mintproject/mint_dt
baseCommand: ["config.yaml"]
requirements:
  NetworkAccess:
    networkAccess: true
  InitialWorkDirRequirement:
    listing:
      - entryname: config.yaml
        entry: |-
          version: "1"
          description: Data transformation to generate TopoFlow-ready precipitation files (RTS/RTI) from GLDAS/GPM data sources
          inputs:
            dataset_id:
              comment: Dataset ID
              value: $(inputs.dataset_id)
            start_time:
              comment: Start time to filter Resources for DataCatalog GLDAS/GPM Dataset ("YYYY-MM-DD HH:MM:SS" format or "null" to leave this end open)
              value: $(inputs.start_time)
            end_time:
              comment: End time to filter Resources for DataCatalog GLDAS/GPM Dataset ("YYYY-MM-DD HH:MM:SS" format or "null" to leave this end open)
              value: $(inputs.end_time)
            var_name:
              comment: GLDAS Standard Variable name for which transformation is to be performed
              value: $(inputs.var_name)
            bounding_box:
              comment: Bounding box of the extracting region in "x_min, y_min, x_max, y_max" order
              value: $(inputs.bounding_box)
            xres_arcsecs:
              comment: Resolution on x axis
              value: $(inputs.xres_arcsecs)
            yres_arcsecs:
              comment: Resolution on y axis
              value: $(inputs.yres_arcsecs)
            unit_multifier:
              comment: The value that will be multiplied with values of the variable to get its value in mm/hr. GLDAS value is 3600 and GPM value is 1.
              value: $(inputs.unit_multifier)
            output_file:
              comment: The output zip file
              value: $(runtime.outdir)/output.zip
            tmp_dir_geotiff:
              comment: A temporary directory that is used to stored GeoTiff files
              value: tmp/geotiff
            tmp_dir_cropped_geotiff:
              comment: A temporary directory that is used to stored GeoTiff files
              value: tmp/cropped_geotiff
          adapters:
            weather_data:
              comment: |
                Weather dataset
              adapter: funcs.DcatReadFunc
              inputs:
                dataset_id: $$.dataset_id
                start_time: $$.start_time
                end_time: $$.end_time
            geotiff_writer:
              adapter: funcs.GeoTiffWriteFunc
              inputs:
                dataset: $.weather_data.data
                variable_name: $$.var_name
                output_dir: $$.tmp_dir_geotiff
            tf_trans:
              adapter: funcs.topoflow.topoflow_climate.Topoflow4ClimateWriteWrapperFunc
              inputs:
                geotiff_files: $.geotiff_writer.output_files
                cropped_geotiff_dir: $$.tmp_dir_cropped_geotiff
                output_file: $$.output_file
                bounds: $$.bounding_box
                xres_arcsecs: $$.xres_arcsecs
                yres_arcsecs: $$.yres_arcsecs
                unit_multiplier: $$.unit_multifier
inputs:
  dataset_id:
    type: string
  start_time:
    type: string
  end_time:
    type: string
  var_name:
    type: string
  bounding_box:
    type: string
  xres_arcsecs:
    type: int
  yres_arcsecs:
    type: int
  unit_multifier:
    type: int

outputs:
  config_file:
    type: File
    outputBinding:
       glob: output.zip

