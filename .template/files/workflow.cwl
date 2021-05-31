#!/usr/bin/env cwl-runner

cwlVersion: v1.1
class: Workflow
inputs:
  outputdir:
    type: string
    default: /tmp/output.zip
  var_name:
    type: string
    label: "Variable to extract values"
  bounding_box:
    type: string
    label: "Bounding box of the extracting region"
  xres_arcsecs:
    type: int
    label: "Resolution on x axis"
  yres_arcsecs:
    type: int
    label: "Resolution on y axis"
  zipfile:
    type: File
    label: "A zipfile contains a directory (any name) with nc4 files"  
outputs:
  output_compressed:
    type: File
    outputSource: transform/output_compressed
    label: "A zipfile with rts and rti files"
    
steps:
  extract:
    run: zip.cwl
    in:
      zipfile: zipfile
    out: [directory]
  transform:
    run: dt.cwl
    in:
      input_dir: extract/directory
      var_name: var_name
      outputdir: outputdir
      bounding_box: bounding_box
      xres_arcsecs: xres_arcsecs
      yres_arcsecs: yres_arcsecs
    out: [output_compressed]
