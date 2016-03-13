
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl" 
load "./shapefile_mask_data_mod.ncl"

begin
;--- Identify region
  region = "STATE/PROVINCE"

;---Name of shapefile 
   shp_fname = "../data/IND_adm1.shp"

;---Rough area we are interested in. Everything outside this will be masked.
   minlat = 0.0
   maxlat = 40.0
   minlon = 65.0
   maxlon = 105.0

;---Blank file of region to build mask from 
   data_fname = addfile("../data/India.blank.ncepgrid.nc","r")
   x = data_fname->const
   mask_fname = "mask.nc"        ; name output file

;---Create a new mask using a shapefile 
   opt             = True
   opt@return_mask = True
   opt@minlon      = minlon     ; Makes the shapefile masking
   opt@maxlon      = maxlon     ; go faster.
   opt@minlat      = minlat
   opt@maxlat      = maxlat

   opt@debug       = True
   opt@shape_var   = "NAME_1"
   opt@shape_names = region
   opt@delta_kilometers = 50
   region_mask     = shapefile_mask_data_mod(x,shp_fname,opt)
   copy_VarMeta(x,region_mask)
   
;---Write new mask to file
   system("rm -f " + mask_fname)
   fout           = addfile(mask_fname,"c")
   fout->region_mask = region_mask

end
