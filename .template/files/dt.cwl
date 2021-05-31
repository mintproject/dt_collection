#!/usr/bin/env cwl-runner

cwlVersion: v1.1 
class: CommandLineTool
hints:
  DockerRequirement:
    dockerImageId: mintproject/mint_dt
baseCommand: ["config.yaml"]
requirements:
  InitialWorkDirRequirement:
    listing:
      - entryname: config.yaml
        entry: |-
            version: "1"
            description: Data transformation to generate TopoFlow-ready precipitation files (RTS) from Global Precipitation Measurement (GPM) data sources
            inputs:
              input_dir:
                comment: "Path to input directory"
                value: $(inputs.input_dir.path)
              temp_dir:
                comment: "Path to temporary diretory (to store temp files generated)"
                value: "/tmp/"
              output_file:
                comment: "Path to output directory"
                value: $(runtime.outdir)/output.zip
              var_name:
                comment: "Variable to extract values"
                value: $(inputs.var_name)
              bounding_box:
                comment: "Bounding box of the extracting region"
                value: $(inputs.bounding_box)
              xres_arcsecs:
                comment: "Resolution on x axis"
                value: "30"
              yres_arcsecs:
                comment: "Resolution on y axis"
                value: "30"
            adapters:
              tf_climate:
                comment: My topoflow climate write adapter
                adapter: funcs.Topoflow4ClimateWriteFunc
                inputs:
                  input_dir: $$.input_dir
                  temp_dir: $$.temp_dir
                  output_file: $$.output_file
                  var_name: $$.var_name
                  DEM_bounds: $$.bounding_box
                  DEM_xres_arcsecs: $$.xres_arcsecs
                  DEM_yres_arcsecs: $$.yres_arcsecs
inputs:
  input_dir:
    type: Directory
  outputdir:
    type: string
    default: /tmp/output.zip
  var_name:
    type: string
  bounding_box:
    type: string
  xres_arcsecs:
    type: int
  yres_arcsecs:
    type: int

outputs:
  output_compressed:
    type: File
    outputBinding:
       glob: output.zip
