class CreateCountries < ActiveRecord::Migration
  def self.up
    create_table :countries do |t|
      t.string :name, :alpha2, :alpha3
      t.integer :unsubregion_id, :unregion_id
      t.timestamps
    end
    
      country = Country.new
      country.id = 4
      country.name = "Afghanistan"
      country.alpha2 = "AF"
      country.alpha3 = "AFG"
      country.unregion_id = 1
      country.unsubregion_id = 1
      country.save!
          
      country = Country.new
      country.id = 8
      country.name = "Albania"
      country.alpha2 = "AL"
      country.alpha3 = "ALB"
      country.unregion_id = 2
      country.unsubregion_id = 2
      country.save!
          
      country = Country.new
      country.id = 10
      country.name = "Antarctica"
      country.alpha2 = "AQ"
      country.alpha3 = "ATA"
      country.unregion_id = nil
      country.unsubregion_id = nil
      country.save!
          
      country = Country.new
      country.id = 12
      country.name = "Algeria"
      country.alpha2 = "DZ"
      country.alpha3 = "DZA"
      country.unregion_id = 3
      country.unsubregion_id = 3
      country.save!
          
      country = Country.new
      country.id = 16
      country.name = "American Samoa"
      country.alpha2 = "AS"
      country.alpha3 = "ASM"
      country.unregion_id = 4
      country.unsubregion_id = 4
      country.save!
          
      country = Country.new
      country.id = 20
      country.name = "Andorra"
      country.alpha2 = "AD"
      country.alpha3 = "AND"
      country.unregion_id = 2
      country.unsubregion_id = 2
      country.save!
          
      country = Country.new
      country.id = 24
      country.name = "Angola"
      country.alpha2 = "AO"
      country.alpha3 = "AGO"
      country.unregion_id = 3
      country.unsubregion_id = 5
      country.save!
          
      country = Country.new
      country.id = 28
      country.name = "Antigua and Barbuda"
      country.alpha2 = "AG"
      country.alpha3 = "ATG"
      country.unregion_id = 4
      country.unsubregion_id = 6
      country.save!
          
      country = Country.new
      country.id = 31
      country.name = "Azerbaijan"
      country.alpha2 = "AZ"
      country.alpha3 = "AZE"
      country.unregion_id = 1
      country.unsubregion_id = 8
      country.save!
          
      country = Country.new
      country.id = 32
      country.name = "Argentina"
      country.alpha2 = "AR"
      country.alpha3 = "ARG"
      country.unregion_id = 4
      country.unsubregion_id = 7
      country.save!
          
      country = Country.new
      country.id = 36
      country.name = "Australia"
      country.alpha2 = "AU"
      country.alpha3 = "AUS"
      country.unregion_id = 4
      country.unsubregion_id = 9
      country.save!
          
      country = Country.new
      country.id = 40
      country.name = "Austria"
      country.alpha2 = "AT"
      country.alpha3 = "AUT"
      country.unregion_id = 2
      country.unsubregion_id = 10
      country.save!
          
      country = Country.new
      country.id = 44
      country.name = "Bahamas"
      country.alpha2 = "BS"
      country.alpha3 = "BHS"
      country.unregion_id = 4
      country.unsubregion_id = 6
      country.save!
          
      country = Country.new
      country.id = 48
      country.name = "Bahrain"
      country.alpha2 = "BH"
      country.alpha3 = "BHR"
      country.unregion_id = 1
      country.unsubregion_id = 8
      country.save!
          
      country = Country.new
      country.id = 50
      country.name = "Bangladesh"
      country.alpha2 = "BD"
      country.alpha3 = "BGD"
      country.unregion_id = 1
      country.unsubregion_id = 1
      country.save!
          
      country = Country.new
      country.id = 51
      country.name = "Armenia"
      country.alpha2 = "AM"
      country.alpha3 = "ARM"
      country.unregion_id = 1
      country.unsubregion_id = 8
      country.save!
          
      country = Country.new
      country.id = 52
      country.name = "Barbados"
      country.alpha2 = "BB"
      country.alpha3 = "BRB"
      country.unregion_id = 4
      country.unsubregion_id = 6
      country.save!
          
      country = Country.new
      country.id = 56
      country.name = "Belgium"
      country.alpha2 = "BE"
      country.alpha3 = "BEL"
      country.unregion_id = 2
      country.unsubregion_id = 10
      country.save!
          
      country = Country.new
      country.id = 60
      country.name = "Bermuda"
      country.alpha2 = "BM"
      country.alpha3 = "BMU"
      country.unregion_id = 4
      country.unsubregion_id = 14
      country.save!
          
      country = Country.new
      country.id = 64
      country.name = "Bhutan"
      country.alpha2 = "BT"
      country.alpha3 = "BTN"
      country.unregion_id = 1
      country.unsubregion_id = 1
      country.save!
          
      country = Country.new
      country.id = 68
      country.name = "Bolivia"
      country.alpha2 = "BO"
      country.alpha3 = "BOL"
      country.unregion_id = 4
      country.unsubregion_id = 7
      country.save!
          
      country = Country.new
      country.id = 70
      country.name = "Bosnia and Herzegovina"
      country.alpha2 = "BA"
      country.alpha3 = "BIH"
      country.unregion_id = 2
      country.unsubregion_id = 2
      country.save!
          
      country = Country.new
      country.id = 72
      country.name = "Botswana"
      country.alpha2 = "BW"
      country.alpha3 = "BWA"
      country.unregion_id = 3
      country.unsubregion_id = 15
      country.save!
          
      country = Country.new
      country.id = 74
      country.name = "Bouvet Island"
      country.alpha2 = "BV"
      country.alpha3 = "BVT"
      country.unregion_id = nil
      country.unsubregion_id = nil
      country.save!
          
      country = Country.new
      country.id = 76
      country.name = "Brazil"
      country.alpha2 = "BR"
      country.alpha3 = "BRA"
      country.unregion_id = 4
      country.unsubregion_id = 7
      country.save!
          
      country = Country.new
      country.id = 84
      country.name = "Belize"
      country.alpha2 = "BZ"
      country.alpha3 = "BLZ"
      country.unregion_id = 4
      country.unsubregion_id = 12
      country.save!
          
      country = Country.new
      country.id = 86
      country.name = "British Indian Ocean Territory"
      country.alpha2 = "IO"
      country.alpha3 = "IOT"
      country.unregion_id = 3
      country.unsubregion_id = 16
      country.save!
          
      country = Country.new
      country.id = 90
      country.name = "Solomon Islands"
      country.alpha2 = "SB"
      country.alpha3 = "SLB"
      country.unregion_id = 4
      country.unsubregion_id = 20
      country.save!
          
      country = Country.new
      country.id = 92
      country.name = "Virgin Islands, British"
      country.alpha2 = "VG"
      country.alpha3 = "VGB"
      country.unregion_id = 4
      country.unsubregion_id = 6
      country.save!
          
      country = Country.new
      country.id = 96
      country.name = "Brunei Darussalam"
      country.alpha2 = "BN"
      country.alpha3 = "BRN"
      country.unregion_id = 1
      country.unsubregion_id = 17
      country.save!
          
      country = Country.new
      country.id = 100
      country.name = "Bulgaria"
      country.alpha2 = "BG"
      country.alpha3 = "BGR"
      country.unregion_id = 2
      country.unsubregion_id = 11
      country.save!
          
      country = Country.new
      country.id = 104
      country.name = "Myanmar"
      country.alpha2 = "MM"
      country.alpha3 = "MMR"
      country.unregion_id = 1
      country.unsubregion_id = 17
      country.save!
          
      country = Country.new
      country.id = 108
      country.name = "Burundi"
      country.alpha2 = "BI"
      country.alpha3 = "BDI"
      country.unregion_id = 3
      country.unsubregion_id = 16
      country.save!
          
      country = Country.new
      country.id = 112
      country.name = "Belarus"
      country.alpha2 = "BY"
      country.alpha3 = "BLR"
      country.unregion_id = 2
      country.unsubregion_id = 11
      country.save!
          
      country = Country.new
      country.id = 116
      country.name = "Cambodia"
      country.alpha2 = "KH"
      country.alpha3 = "KHM"
      country.unregion_id = 1
      country.unsubregion_id = 17
      country.save!
          
      country = Country.new
      country.id = 120
      country.name = "Cameroon"
      country.alpha2 = "CM"
      country.alpha3 = "CMR"
      country.unregion_id = 3
      country.unsubregion_id = 5
      country.save!
          
      country = Country.new
      country.id = 124
      country.name = "Canada"
      country.alpha2 = "CA"
      country.alpha3 = "CAN"
      country.unregion_id = 4
      country.unsubregion_id = 14
      country.save!
          
      country = Country.new
      country.id = 132
      country.name = "Cape Verde"
      country.alpha2 = "CV"
      country.alpha3 = "CPV"
      country.unregion_id = 3
      country.unsubregion_id = 13
      country.save!
          
      country = Country.new
      country.id = 136
      country.name = "Cayman Islands"
      country.alpha2 = "KY"
      country.alpha3 = "CYM"
      country.unregion_id = 4
      country.unsubregion_id = 6
      country.save!
          
      country = Country.new
      country.id = 140
      country.name = "Central African Republic"
      country.alpha2 = "CF"
      country.alpha3 = "CAF"
      country.unregion_id = 3
      country.unsubregion_id = 5
      country.save!
          
      country = Country.new
      country.id = 144
      country.name = "Sri Lanka"
      country.alpha2 = "LK"
      country.alpha3 = "LKA"
      country.unregion_id = 1
      country.unsubregion_id = 1
      country.save!
          
      country = Country.new
      country.id = 148
      country.name = "Chad"
      country.alpha2 = "TD"
      country.alpha3 = "TCD"
      country.unregion_id = 3
      country.unsubregion_id = 5
      country.save!
          
      country = Country.new
      country.id = 152
      country.name = "Chile"
      country.alpha2 = "CL"
      country.alpha3 = "CHL"
      country.unregion_id = 4
      country.unsubregion_id = 7
      country.save!
          
      country = Country.new
      country.id = 156
      country.name = "China"
      country.alpha2 = "CN"
      country.alpha3 = "CHN"
      country.unregion_id = 1
      country.unsubregion_id = 18
      country.save!
          
      country = Country.new
      country.id = 158
      country.name = "Taiwan, Province Of China"
      country.alpha2 = "TW"
      country.alpha3 = "TWN"
      country.unregion_id = 1
      country.unsubregion_id = 18
      country.save!
          
      country = Country.new
      country.id = 162
      country.name = "Christmas Island"
      country.alpha2 = "CX"
      country.alpha3 = "CXR"
      country.unregion_id = 4
      country.unsubregion_id = 9
      country.save!
          
      country = Country.new
      country.id = 166
      country.name = "Cocos Keeling Islands"
      country.alpha2 = "CC"
      country.alpha3 = "CCK"
      country.unregion_id = 4
      country.unsubregion_id = 9
      country.save!
          
      country = Country.new
      country.id = 170
      country.name = "Colombia"
      country.alpha2 = "CO"
      country.alpha3 = "COL"
      country.unregion_id = 4
      country.unsubregion_id = 7
      country.save!
          
      country = Country.new
      country.id = 174
      country.name = "Comoros"
      country.alpha2 = "KM"
      country.alpha3 = "COM"
      country.unregion_id = 3
      country.unsubregion_id = 16
      country.save!
          
      country = Country.new
      country.id = 175
      country.name = "Mayotte"
      country.alpha2 = "YT"
      country.alpha3 = "MYT"
      country.unregion_id = 3
      country.unsubregion_id = 16
      country.save!
          
      country = Country.new
      country.id = 178
      country.name = "Congo"
      country.alpha2 = "CG"
      country.alpha3 = "COG"
      country.unregion_id = 3
      country.unsubregion_id = 5
      country.save!
          
      country = Country.new
      country.id = 180
      country.name = "Congo, The Democratic Republic Of The"
      country.alpha2 = "CD"
      country.alpha3 = "COD"
      country.unregion_id = 3
      country.unsubregion_id = 5
      country.save!
          
      country = Country.new
      country.id = 184
      country.name = "Cook Islands"
      country.alpha2 = "CK"
      country.alpha3 = "COK"
      country.unregion_id = 4
      country.unsubregion_id = 4
      country.save!
          
      country = Country.new
      country.id = 188
      country.name = "Costa Rica"
      country.alpha2 = "CR"
      country.alpha3 = "CRI"
      country.unregion_id = 4
      country.unsubregion_id = 12
      country.save!
          
      country = Country.new
      country.id = 191
      country.name = "Croatia"
      country.alpha2 = "HR"
      country.alpha3 = "HRV"
      country.unregion_id = 2
      country.unsubregion_id = 2
      country.save!
          
      country = Country.new
      country.id = 192
      country.name = "Cuba"
      country.alpha2 = "CU"
      country.alpha3 = "CUB"
      country.unregion_id = 4
      country.unsubregion_id = 6
      country.save!
          
      country = Country.new
      country.id = 196
      country.name = "Cyprus"
      country.alpha2 = "CY"
      country.alpha3 = "CYP"
      country.unregion_id = 1
      country.unsubregion_id = 8
      country.save!
          
      country = Country.new
      country.id = 203
      country.name = "Czech Republic"
      country.alpha2 = "CZ"
      country.alpha3 = "CZE"
      country.unregion_id = 2
      country.unsubregion_id = 11
      country.save!
          
      country = Country.new
      country.id = 204
      country.name = "Benin"
      country.alpha2 = "BJ"
      country.alpha3 = "BEN"
      country.unregion_id = 3
      country.unsubregion_id = 13
      country.save!
          
      country = Country.new
      country.id = 208
      country.name = "Denmark"
      country.alpha2 = "DK"
      country.alpha3 = "DNK"
      country.unregion_id = 2
      country.unsubregion_id = 19
      country.save!
          
      country = Country.new
      country.id = 212
      country.name = "Dominica"
      country.alpha2 = "DM"
      country.alpha3 = "DMA"
      country.unregion_id = 4
      country.unsubregion_id = 6
      country.save!
          
      country = Country.new
      country.id = 214
      country.name = "Dominican Republic"
      country.alpha2 = "DO"
      country.alpha3 = "DOM"
      country.unregion_id = 4
      country.unsubregion_id = 6
      country.save!
          
      country = Country.new
      country.id = 218
      country.name = "Ecuador"
      country.alpha2 = "EC"
      country.alpha3 = "ECU"
      country.unregion_id = 4
      country.unsubregion_id = 7
      country.save!
          
      country = Country.new
      country.id = 222
      country.name = "El Salvador"
      country.alpha2 = "SV"
      country.alpha3 = "SLV"
      country.unregion_id = 4
      country.unsubregion_id = 12
      country.save!
          
      country = Country.new
      country.id = 226
      country.name = "Equatorial Guinea"
      country.alpha2 = "GQ"
      country.alpha3 = "GNQ"
      country.unregion_id = 3
      country.unsubregion_id = 5
      country.save!
          
      country = Country.new
      country.id = 231
      country.name = "Ethiopia"
      country.alpha2 = "ET"
      country.alpha3 = "ETH"
      country.unregion_id = 3
      country.unsubregion_id = 16
      country.save!
          
      country = Country.new
      country.id = 232
      country.name = "Eritrea"
      country.alpha2 = "ER"
      country.alpha3 = "ERI"
      country.unregion_id = 3
      country.unsubregion_id = 16
      country.save!
          
      country = Country.new
      country.id = 233
      country.name = "Estonia"
      country.alpha2 = "EE"
      country.alpha3 = "EST"
      country.unregion_id = 2
      country.unsubregion_id = 19
      country.save!
          
      country = Country.new
      country.id = 234
      country.name = "Faroe Islands"
      country.alpha2 = "FO"
      country.alpha3 = "FRO"
      country.unregion_id = 2
      country.unsubregion_id = 19
      country.save!
          
      country = Country.new
      country.id = 238
      country.name = "Falkland Islands Malvinas"
      country.alpha2 = "FK"
      country.alpha3 = "FLK"
      country.unregion_id = 4
      country.unsubregion_id = 7
      country.save!
          
      country = Country.new
      country.id = 239
      country.name = "South Georgia and the South Sandwich Islands"
      country.alpha2 = "GS"
      country.alpha3 = "SGS"
      country.unregion_id = 4
      country.unsubregion_id = 7
      country.save!
          
      country = Country.new
      country.id = 242
      country.name = "Fiji"
      country.alpha2 = "FJ"
      country.alpha3 = "FJI"
      country.unregion_id = 4
      country.unsubregion_id = 20
      country.save!
          
      country = Country.new
      country.id = 246
      country.name = "Finland"
      country.alpha2 = "FI"
      country.alpha3 = "FIN"
      country.unregion_id = 2
      country.unsubregion_id = 19
      country.save!
          
      country = Country.new
      country.id = 248
      country.name = "Åland Islands"
      country.alpha2 = "AX"
      country.alpha3 = "ALA"
      country.unregion_id = 2
      country.unsubregion_id = 19
      country.save!
          
      country = Country.new
      country.id = 250
      country.name = "France"
      country.alpha2 = "FR"
      country.alpha3 = "FRA"
      country.unregion_id = 2
      country.unsubregion_id = 10
      country.save!
          
      country = Country.new
      country.id = 254
      country.name = "French Guiana"
      country.alpha2 = "GF"
      country.alpha3 = "GUF"
      country.unregion_id = 4
      country.unsubregion_id = 7
      country.save!
          
      country = Country.new
      country.id = 258
      country.name = "French Polynesia"
      country.alpha2 = "PF"
      country.alpha3 = "PYF"
      country.unregion_id = 4
      country.unsubregion_id = 4
      country.save!
          
      country = Country.new
      country.id = 260
      country.name = "French Southern Territories"
      country.alpha2 = "TF"
      country.alpha3 = "ATF"
      country.unregion_id = nil
      country.unsubregion_id = nil
      country.save!
          
      country = Country.new
      country.id = 262
      country.name = "Djibouti"
      country.alpha2 = "DJ"
      country.alpha3 = "DJI"
      country.unregion_id = 3
      country.unsubregion_id = 16
      country.save!
          
      country = Country.new
      country.id = 266
      country.name = "Gabon"
      country.alpha2 = "GA"
      country.alpha3 = "GAB"
      country.unregion_id = 3
      country.unsubregion_id = 5
      country.save!
          
      country = Country.new
      country.id = 268
      country.name = "Georgia"
      country.alpha2 = "GE"
      country.alpha3 = "GEO"
      country.unregion_id = 1
      country.unsubregion_id = 8
      country.save!
          
      country = Country.new
      country.id = 270
      country.name = "Gambia"
      country.alpha2 = "GM"
      country.alpha3 = "GMB"
      country.unregion_id = 3
      country.unsubregion_id = 13
      country.save!
          
      country = Country.new
      country.id = 275
      country.name = "Palestinian Territory, Occupied"
      country.alpha2 = "PS"
      country.alpha3 = "PSE"
      country.unregion_id = 1
      country.unsubregion_id = 8
      country.save!
          
      country = Country.new
      country.id = 276
      country.name = "Germany"
      country.alpha2 = "DE"
      country.alpha3 = "DEU"
      country.unregion_id = 2
      country.unsubregion_id = 10
      country.save!
          
      country = Country.new
      country.id = 288
      country.name = "Ghana"
      country.alpha2 = "GH"
      country.alpha3 = "GHA"
      country.unregion_id = 3
      country.unsubregion_id = 13
      country.save!
          
      country = Country.new
      country.id = 292
      country.name = "Gibraltar"
      country.alpha2 = "GI"
      country.alpha3 = "GIB"
      country.unregion_id = 2
      country.unsubregion_id = 2
      country.save!
          
      country = Country.new
      country.id = 296
      country.name = "Kiribati"
      country.alpha2 = "KI"
      country.alpha3 = "KIR"
      country.unregion_id = 4
      country.unsubregion_id = 21
      country.save!
          
      country = Country.new
      country.id = 300
      country.name = "Greece"
      country.alpha2 = "GR"
      country.alpha3 = "GRC"
      country.unregion_id = 2
      country.unsubregion_id = 2
      country.save!
          
      country = Country.new
      country.id = 304
      country.name = "Greenland"
      country.alpha2 = "GL"
      country.alpha3 = "GRL"
      country.unregion_id = 4
      country.unsubregion_id = 14
      country.save!
          
      country = Country.new
      country.id = 308
      country.name = "Grenada"
      country.alpha2 = "GD"
      country.alpha3 = "GRD"
      country.unregion_id = 4
      country.unsubregion_id = 6
      country.save!
          
      country = Country.new
      country.id = 312
      country.name = "Guadeloupe"
      country.alpha2 = "GP"
      country.alpha3 = "GLP"
      country.unregion_id = 4
      country.unsubregion_id = 6
      country.save!
          
      country = Country.new
      country.id = 316
      country.name = "Guam"
      country.alpha2 = "GU"
      country.alpha3 = "GUM"
      country.unregion_id = 4
      country.unsubregion_id = 21
      country.save!
          
      country = Country.new
      country.id = 320
      country.name = "Guatemala"
      country.alpha2 = "GT"
      country.alpha3 = "GTM"
      country.unregion_id = 4
      country.unsubregion_id = 12
      country.save!
          
      country = Country.new
      country.id = 324
      country.name = "Guinea"
      country.alpha2 = "GN"
      country.alpha3 = "GIN"
      country.unregion_id = 3
      country.unsubregion_id = 13
      country.save!
          
      country = Country.new
      country.id = 328
      country.name = "Guyana"
      country.alpha2 = "GY"
      country.alpha3 = "GUY"
      country.unregion_id = 4
      country.unsubregion_id = 7
      country.save!
          
      country = Country.new
      country.id = 332
      country.name = "Haiti"
      country.alpha2 = "HT"
      country.alpha3 = "HTI"
      country.unregion_id = 4
      country.unsubregion_id = 6
      country.save!
          
      country = Country.new
      country.id = 334
      country.name = "Heard and McDonald Islands"
      country.alpha2 = "HM"
      country.alpha3 = "HMD"
      country.unregion_id = nil
      country.unsubregion_id = nil
      country.save!
          
      country = Country.new
      country.id = 336
      country.name = "Holy See Vatican City State"
      country.alpha2 = "VA"
      country.alpha3 = "VAT"
      country.unregion_id = 2
      country.unsubregion_id = 2
      country.save!
          
      country = Country.new
      country.id = 340
      country.name = "Honduras"
      country.alpha2 = "HN"
      country.alpha3 = "HND"
      country.unregion_id = 4
      country.unsubregion_id = 12
      country.save!
          
      country = Country.new
      country.id = 344
      country.name = "Hong Kong"
      country.alpha2 = "HK"
      country.alpha3 = "HKG"
      country.unregion_id = 1
      country.unsubregion_id = 18
      country.save!
          
      country = Country.new
      country.id = 348
      country.name = "Hungary"
      country.alpha2 = "HU"
      country.alpha3 = "HUN"
      country.unregion_id = 2
      country.unsubregion_id = 11
      country.save!
          
      country = Country.new
      country.id = 352
      country.name = "Iceland"
      country.alpha2 = "IS"
      country.alpha3 = "ISL"
      country.unregion_id = 2
      country.unsubregion_id = 19
      country.save!
          
      country = Country.new
      country.id = 356
      country.name = "India"
      country.alpha2 = "IN"
      country.alpha3 = "IND"
      country.unregion_id = 1
      country.unsubregion_id = 1
      country.save!
          
      country = Country.new
      country.id = 360
      country.name = "Indonesia"
      country.alpha2 = "ID"
      country.alpha3 = "IDN"
      country.unregion_id = 1
      country.unsubregion_id = 17
      country.save!
          
      country = Country.new
      country.id = 364
      country.name = "Iran Islamic Republic Of"
      country.alpha2 = "IR"
      country.alpha3 = "IRN"
      country.unregion_id = 1
      country.unsubregion_id = 1
      country.save!
          
      country = Country.new
      country.id = 368
      country.name = "Iraq"
      country.alpha2 = "IQ"
      country.alpha3 = "IRQ"
      country.unregion_id = 1
      country.unsubregion_id = 8
      country.save!
          
      country = Country.new
      country.id = 372
      country.name = "Ireland"
      country.alpha2 = "IE"
      country.alpha3 = "IRL"
      country.unregion_id = 2
      country.unsubregion_id = 19
      country.save!
          
      country = Country.new
      country.id = 376
      country.name = "Israel"
      country.alpha2 = "IL"
      country.alpha3 = "ISR"
      country.unregion_id = 1
      country.unsubregion_id = 8
      country.save!
          
      country = Country.new
      country.id = 380
      country.name = "Italy"
      country.alpha2 = "IT"
      country.alpha3 = "ITA"
      country.unregion_id = 2
      country.unsubregion_id = 2
      country.save!
          
      country = Country.new
      country.id = 384
      country.name = "Cote D\'Ivoire"
      country.alpha2 = "CI"
      country.alpha3 = "CIV"
      country.unregion_id = 3
      country.unsubregion_id = 13
      country.save!
          
      country = Country.new
      country.id = 388
      country.name = "Jamaica"
      country.alpha2 = "JM"
      country.alpha3 = "JAM"
      country.unregion_id = 4
      country.unsubregion_id = 6
      country.save!
          
      country = Country.new
      country.id = 392
      country.name = "Japan"
      country.alpha2 = "JP"
      country.alpha3 = "JPN"
      country.unregion_id = 1
      country.unsubregion_id = 18
      country.save!
          
      country = Country.new
      country.id = 398
      country.name = "Kazakhstan"
      country.alpha2 = "KZ"
      country.alpha3 = "KAZ"
      country.unregion_id = 1
      country.unsubregion_id = 22
      country.save!
          
      country = Country.new
      country.id = 400
      country.name = "Jordan"
      country.alpha2 = "JO"
      country.alpha3 = "JOR"
      country.unregion_id = 1
      country.unsubregion_id = 8
      country.save!
          
      country = Country.new
      country.id = 404
      country.name = "Kenya"
      country.alpha2 = "KE"
      country.alpha3 = "KEN"
      country.unregion_id = 3
      country.unsubregion_id = 16
      country.save!
          
      country = Country.new
      country.id = 408
      country.name = "Korea, Democratic People\'s Republic Of"
      country.alpha2 = "KP"
      country.alpha3 = "PRK"
      country.unregion_id = 1
      country.unsubregion_id = 18
      country.save!
          
      country = Country.new
      country.id = 410
      country.name = "Korea, Republic of"
      country.alpha2 = "KR"
      country.alpha3 = "KOR"
      country.unregion_id = 1
      country.unsubregion_id = 18
      country.save!
          
      country = Country.new
      country.id = 414
      country.name = "Kuwait"
      country.alpha2 = "KW"
      country.alpha3 = "KWT"
      country.unregion_id = 1
      country.unsubregion_id = 8
      country.save!
          
      country = Country.new
      country.id = 417
      country.name = "Kyrgyzstan"
      country.alpha2 = "KG"
      country.alpha3 = "KGZ"
      country.unregion_id = 1
      country.unsubregion_id = 22
      country.save!
          
      country = Country.new
      country.id = 418
      country.name = "Lao People\'s Democratic Republic"
      country.alpha2 = "LA"
      country.alpha3 = "LAO"
      country.unregion_id = 1
      country.unsubregion_id = 17
      country.save!
          
      country = Country.new
      country.id = 422
      country.name = "Lebanon"
      country.alpha2 = "LB"
      country.alpha3 = "LBN"
      country.unregion_id = 1
      country.unsubregion_id = 8
      country.save!
          
      country = Country.new
      country.id = 426
      country.name = "Lesotho"
      country.alpha2 = "LS"
      country.alpha3 = "LSO"
      country.unregion_id = 3
      country.unsubregion_id = 15
      country.save!
          
      country = Country.new
      country.id = 428
      country.name = "Latvia"
      country.alpha2 = "LV"
      country.alpha3 = "LVA"
      country.unregion_id = 2
      country.unsubregion_id = 19
      country.save!
          
      country = Country.new
      country.id = 430
      country.name = "Liberia"
      country.alpha2 = "LR"
      country.alpha3 = "LBR"
      country.unregion_id = 3
      country.unsubregion_id = 13
      country.save!
          
      country = Country.new
      country.id = 434
      country.name = "Libyan Arab Jamahiriya"
      country.alpha2 = "LY"
      country.alpha3 = "LBY"
      country.unregion_id = 3
      country.unsubregion_id = 3
      country.save!
          
      country = Country.new
      country.id = 438
      country.name = "Liechtenstein"
      country.alpha2 = "LI"
      country.alpha3 = "LIE"
      country.unregion_id = 2
      country.unsubregion_id = 10
      country.save!
          
      country = Country.new
      country.id = 440
      country.name = "Lithuania"
      country.alpha2 = "LT"
      country.alpha3 = "LTU"
      country.unregion_id = 2
      country.unsubregion_id = 19
      country.save!
          
      country = Country.new
      country.id = 442
      country.name = "Luxembourg"
      country.alpha2 = "LU"
      country.alpha3 = "LUX"
      country.unregion_id = 2
      country.unsubregion_id = 10
      country.save!
          
      country = Country.new
      country.id = 446
      country.name = "Macao"
      country.alpha2 = "MO"
      country.alpha3 = "MAC"
      country.unregion_id = 1
      country.unsubregion_id = 18
      country.save!
          
      country = Country.new
      country.id = 450
      country.name = "Madagascar"
      country.alpha2 = "MG"
      country.alpha3 = "MDG"
      country.unregion_id = 3
      country.unsubregion_id = 16
      country.save!
          
      country = Country.new
      country.id = 454
      country.name = "Malawi"
      country.alpha2 = "MW"
      country.alpha3 = "MWI"
      country.unregion_id = 3
      country.unsubregion_id = 16
      country.save!
          
      country = Country.new
      country.id = 458
      country.name = "Malaysia"
      country.alpha2 = "MY"
      country.alpha3 = "MYS"
      country.unregion_id = 1
      country.unsubregion_id = 17
      country.save!
          
      country = Country.new
      country.id = 462
      country.name = "Maldives"
      country.alpha2 = "MV"
      country.alpha3 = "MDV"
      country.unregion_id = 1
      country.unsubregion_id = 1
      country.save!
          
      country = Country.new
      country.id = 466
      country.name = "Mali"
      country.alpha2 = "ML"
      country.alpha3 = "MLI"
      country.unregion_id = 3
      country.unsubregion_id = 13
      country.save!
          
      country = Country.new
      country.id = 470
      country.name = "Malta"
      country.alpha2 = "MT"
      country.alpha3 = "MLT"
      country.unregion_id = 2
      country.unsubregion_id = 2
      country.save!
          
      country = Country.new
      country.id = 474
      country.name = "Martinique"
      country.alpha2 = "MQ"
      country.alpha3 = "MTQ"
      country.unregion_id = 4
      country.unsubregion_id = 6
      country.save!
          
      country = Country.new
      country.id = 478
      country.name = "Mauritania"
      country.alpha2 = "MR"
      country.alpha3 = "MRT"
      country.unregion_id = 3
      country.unsubregion_id = 13
      country.save!
          
      country = Country.new
      country.id = 480
      country.name = "Mauritius"
      country.alpha2 = "MU"
      country.alpha3 = "MUS"
      country.unregion_id = 3
      country.unsubregion_id = 16
      country.save!
          
      country = Country.new
      country.id = 484
      country.name = "Mexico"
      country.alpha2 = "MX"
      country.alpha3 = "MEX"
      country.unregion_id = 4
      country.unsubregion_id = 12
      country.save!
          
      country = Country.new
      country.id = 492
      country.name = "Monaco"
      country.alpha2 = "MC"
      country.alpha3 = "MCO"
      country.unregion_id = 2
      country.unsubregion_id = 10
      country.save!
          
      country = Country.new
      country.id = 496
      country.name = "Mongolia"
      country.alpha2 = "MN"
      country.alpha3 = "MNG"
      country.unregion_id = 1
      country.unsubregion_id = 18
      country.save!
          
      country = Country.new
      country.id = 498
      country.name = "Moldova, Republic Of"
      country.alpha2 = "MD"
      country.alpha3 = "MDA"
      country.unregion_id = 2
      country.unsubregion_id = 11
      country.save!
          
      country = Country.new
      country.id = 499
      country.name = "Montenegro"
      country.alpha2 = "ME"
      country.alpha3 = "MNE"
      country.unregion_id = 2
      country.unsubregion_id = 2
      country.save!
          
      country = Country.new
      country.id = 500
      country.name = "Montserrat"
      country.alpha2 = "MS"
      country.alpha3 = "MSR"
      country.unregion_id = 4
      country.unsubregion_id = 6
      country.save!
          
      country = Country.new
      country.id = 504
      country.name = "Morocco"
      country.alpha2 = "MA"
      country.alpha3 = "MAR"
      country.unregion_id = 3
      country.unsubregion_id = 3
      country.save!
          
      country = Country.new
      country.id = 508
      country.name = "Mozambique"
      country.alpha2 = "MZ"
      country.alpha3 = "MOZ"
      country.unregion_id = 3
      country.unsubregion_id = 16
      country.save!
          
      country = Country.new
      country.id = 512
      country.name = "Oman"
      country.alpha2 = "OM"
      country.alpha3 = "OMN"
      country.unregion_id = 1
      country.unsubregion_id = 8
      country.save!
          
      country = Country.new
      country.id = 516
      country.name = "Namibia"
      country.alpha2 = "NA"
      country.alpha3 = "NAM"
      country.unregion_id = 3
      country.unsubregion_id = 15
      country.save!
          
      country = Country.new
      country.id = 520
      country.name = "Nauru"
      country.alpha2 = "NR"
      country.alpha3 = "NRU"
      country.unregion_id = 4
      country.unsubregion_id = 21
      country.save!
          
      country = Country.new
      country.id = 524
      country.name = "Nepal"
      country.alpha2 = "NP"
      country.alpha3 = "NPL"
      country.unregion_id = 1
      country.unsubregion_id = 1
      country.save!
          
      country = Country.new
      country.id = 528
      country.name = "Netherlands"
      country.alpha2 = "NL"
      country.alpha3 = "NLD"
      country.unregion_id = 2
      country.unsubregion_id = 10
      country.save!
          
      country = Country.new
      country.id = 530
      country.name = "Netherlands Antilles"
      country.alpha2 = "AN"
      country.alpha3 = "ANT"
      country.unregion_id = 4
      country.unsubregion_id = 6
      country.save!
          
      country = Country.new
      country.id = 533
      country.name = "Aruba"
      country.alpha2 = "AW"
      country.alpha3 = "ABW"
      country.unregion_id = 4
      country.unsubregion_id = 6
      country.save!
          
      country = Country.new
      country.id = 540
      country.name = "New Caledonia"
      country.alpha2 = "NC"
      country.alpha3 = "NCL"
      country.unregion_id = 4
      country.unsubregion_id = 20
      country.save!
          
      country = Country.new
      country.id = 548
      country.name = "Vanuatu"
      country.alpha2 = "VU"
      country.alpha3 = "VUT"
      country.unregion_id = 4
      country.unsubregion_id = 20
      country.save!
          
      country = Country.new
      country.id = 554
      country.name = "New Zealand"
      country.alpha2 = "NZ"
      country.alpha3 = "NZL"
      country.unregion_id = 4
      country.unsubregion_id = 9
      country.save!
          
      country = Country.new
      country.id = 558
      country.name = "Nicaragua"
      country.alpha2 = "NI"
      country.alpha3 = "NIC"
      country.unregion_id = 4
      country.unsubregion_id = 12
      country.save!
          
      country = Country.new
      country.id = 562
      country.name = "Niger"
      country.alpha2 = "NE"
      country.alpha3 = "NER"
      country.unregion_id = 3
      country.unsubregion_id = 13
      country.save!
          
      country = Country.new
      country.id = 566
      country.name = "Nigeria"
      country.alpha2 = "NG"
      country.alpha3 = "NGA"
      country.unregion_id = 3
      country.unsubregion_id = 13
      country.save!
          
      country = Country.new
      country.id = 570
      country.name = "Niue"
      country.alpha2 = "NU"
      country.alpha3 = "NIU"
      country.unregion_id = 4
      country.unsubregion_id = 4
      country.save!
          
      country = Country.new
      country.id = 574
      country.name = "Norfolk Island"
      country.alpha2 = "NF"
      country.alpha3 = "NFK"
      country.unregion_id = 4
      country.unsubregion_id = 9
      country.save!
          
      country = Country.new
      country.id = 578
      country.name = "Norway"
      country.alpha2 = "NO"
      country.alpha3 = "NOR"
      country.unregion_id = 2
      country.unsubregion_id = 19
      country.save!
          
      country = Country.new
      country.id = 580
      country.name = "Northern Mariana Islands"
      country.alpha2 = "MP"
      country.alpha3 = "MNP"
      country.unregion_id = 4
      country.unsubregion_id = 21
      country.save!
          
      country = Country.new
      country.id = 581
      country.name = "United States Minor Outlying Islands"
      country.alpha2 = "UM"
      country.alpha3 = "UMI"
      country.unregion_id = 4
      country.unsubregion_id = 14
      country.save!
          
      country = Country.new
      country.id = 583
      country.name = "Micronesia, Federated States Of"
      country.alpha2 = "FM"
      country.alpha3 = "FSM"
      country.unregion_id = 4
      country.unsubregion_id = 21
      country.save!
          
      country = Country.new
      country.id = 584
      country.name = "Marshall Islands"
      country.alpha2 = "MH"
      country.alpha3 = "MHL"
      country.unregion_id = 4
      country.unsubregion_id = 21
      country.save!
          
      country = Country.new
      country.id = 585
      country.name = "Palau"
      country.alpha2 = "PW"
      country.alpha3 = "PLW"
      country.unregion_id = 4
      country.unsubregion_id = 21
      country.save!
          
      country = Country.new
      country.id = 586
      country.name = "Pakistan"
      country.alpha2 = "PK"
      country.alpha3 = "PAK"
      country.unregion_id = 1
      country.unsubregion_id = 1
      country.save!
          
      country = Country.new
      country.id = 591
      country.name = "Panama"
      country.alpha2 = "PA"
      country.alpha3 = "PAN"
      country.unregion_id = 4
      country.unsubregion_id = 12
      country.save!
          
      country = Country.new
      country.id = 598
      country.name = "Papua New Guinea"
      country.alpha2 = "PG"
      country.alpha3 = "PNG"
      country.unregion_id = 4
      country.unsubregion_id = 20
      country.save!
          
      country = Country.new
      country.id = 600
      country.name = "Paraguay"
      country.alpha2 = "PY"
      country.alpha3 = "PRY"
      country.unregion_id = 4
      country.unsubregion_id = 7
      country.save!
          
      country = Country.new
      country.id = 604
      country.name = "Peru"
      country.alpha2 = "PE"
      country.alpha3 = "PER"
      country.unregion_id = 4
      country.unsubregion_id = 7
      country.save!
          
      country = Country.new
      country.id = 608
      country.name = "Philippines"
      country.alpha2 = "PH"
      country.alpha3 = "PHL"
      country.unregion_id = 1
      country.unsubregion_id = 17
      country.save!
          
      country = Country.new
      country.id = 612
      country.name = "Pitcairn"
      country.alpha2 = "PN"
      country.alpha3 = "PCN"
      country.unregion_id = 4
      country.unsubregion_id = 4
      country.save!
          
      country = Country.new
      country.id = 616
      country.name = "Poland"
      country.alpha2 = "PL"
      country.alpha3 = "POL"
      country.unregion_id = 2
      country.unsubregion_id = 11
      country.save!
          
      country = Country.new
      country.id = 620
      country.name = "Portugal"
      country.alpha2 = "PT"
      country.alpha3 = "PRT"
      country.unregion_id = 2
      country.unsubregion_id = 2
      country.save!
          
      country = Country.new
      country.id = 624
      country.name = "Guinea-Bissau"
      country.alpha2 = "GW"
      country.alpha3 = "GNB"
      country.unregion_id = 3
      country.unsubregion_id = 13
      country.save!
          
      country = Country.new
      country.id = 626
      country.name = "Timor-Leste"
      country.alpha2 = "TL"
      country.alpha3 = "TLS"
      country.unregion_id = 1
      country.unsubregion_id = 17
      country.save!
          
      country = Country.new
      country.id = 630
      country.name = "Puerto Rico"
      country.alpha2 = "PR"
      country.alpha3 = "PRI"
      country.unregion_id = 4
      country.unsubregion_id = 6
      country.save!
          
      country = Country.new
      country.id = 634
      country.name = "Qatar"
      country.alpha2 = "QA"
      country.alpha3 = "QAT"
      country.unregion_id = 1
      country.unsubregion_id = 8
      country.save!
          
      country = Country.new
      country.id = 638
      country.name = "Reunion"
      country.alpha2 = "RE"
      country.alpha3 = "REU"
      country.unregion_id = 3
      country.unsubregion_id = 16
      country.save!
          
      country = Country.new
      country.id = 642
      country.name = "Romania"
      country.alpha2 = "RO"
      country.alpha3 = "ROU"
      country.unregion_id = 2
      country.unsubregion_id = 11
      country.save!
          
      country = Country.new
      country.id = 643
      country.name = "Russian Federation"
      country.alpha2 = "RU"
      country.alpha3 = "RUS"
      country.unregion_id = 2
      country.unsubregion_id = 11
      country.save!
          
      country = Country.new
      country.id = 646
      country.name = "Rwanda"
      country.alpha2 = "RW"
      country.alpha3 = "RWA"
      country.unregion_id = 3
      country.unsubregion_id = 16
      country.save!
          
      country = Country.new
      country.id = 652
      country.name = "Saint Barthelemy"
      country.alpha2 = "BL"
      country.alpha3 = "BLM"
      country.unregion_id = 4
      country.unsubregion_id = 6
      country.save!
          
      country = Country.new
      country.id = 654
      country.name = "Saint Helena"
      country.alpha2 = "SH"
      country.alpha3 = "SHN"
      country.unregion_id = 3
      country.unsubregion_id = 13
      country.save!
          
      country = Country.new
      country.id = 659
      country.name = "Saint Kitts And Nevis"
      country.alpha2 = "KN"
      country.alpha3 = "KNA"
      country.unregion_id = 4
      country.unsubregion_id = 6
      country.save!
          
      country = Country.new
      country.id = 660
      country.name = "Anguilla"
      country.alpha2 = "AI"
      country.alpha3 = "AIA"
      country.unregion_id = 4
      country.unsubregion_id = 6
      country.save!
          
      country = Country.new
      country.id = 662
      country.name = "Saint Lucia"
      country.alpha2 = "LC"
      country.alpha3 = "LCA"
      country.unregion_id = 4
      country.unsubregion_id = 6
      country.save!
          
      country = Country.new
      country.id = 663
      country.name = "Saint Martin French part"
      country.alpha2 = "MF"
      country.alpha3 = "MAF"
      country.unregion_id = 4
      country.unsubregion_id = 6
      country.save!
          
      country = Country.new
      country.id = 666
      country.name = "Saint Pierre And Miquelon"
      country.alpha2 = "PM"
      country.alpha3 = "SPM"
      country.unregion_id = 4
      country.unsubregion_id = 14
      country.save!
          
      country = Country.new
      country.id = 670
      country.name = "Saint Vincent And The Grenedines"
      country.alpha2 = "VC"
      country.alpha3 = "VCT"
      country.unregion_id = 4
      country.unsubregion_id = 6
      country.save!
          
      country = Country.new
      country.id = 674
      country.name = "San Marino"
      country.alpha2 = "SM"
      country.alpha3 = "SMR"
      country.unregion_id = 2
      country.unsubregion_id = 2
      country.save!
          
      country = Country.new
      country.id = 678
      country.name = "Sao Tome and Principe"
      country.alpha2 = "ST"
      country.alpha3 = "STP"
      country.unregion_id = 3
      country.unsubregion_id = 5
      country.save!
          
      country = Country.new
      country.id = 682
      country.name = "Saudi Arabia"
      country.alpha2 = "SA"
      country.alpha3 = "SAU"
      country.unregion_id = 1
      country.unsubregion_id = 8
      country.save!
          
      country = Country.new
      country.id = 686
      country.name = "Senegal"
      country.alpha2 = "SN"
      country.alpha3 = "SEN"
      country.unregion_id = 3
      country.unsubregion_id = 13
      country.save!
          
      country = Country.new
      country.id = 688
      country.name = "Serbia"
      country.alpha2 = "RS"
      country.alpha3 = nil
      country.unregion_id = 2
      country.unsubregion_id = 2
      country.save!
          
      country = Country.new
      country.id = 690
      country.name = "Seychelles"
      country.alpha2 = "SC"
      country.alpha3 = "SYC"
      country.unregion_id = 3
      country.unsubregion_id = 16
      country.save!
          
      country = Country.new
      country.id = 694
      country.name = "Sierra Leone"
      country.alpha2 = "SL"
      country.alpha3 = "SLE"
      country.unregion_id = 3
      country.unsubregion_id = 13
      country.save!
          
      country = Country.new
      country.id = 702
      country.name = "Singapore"
      country.alpha2 = "SG"
      country.alpha3 = "SGP"
      country.unregion_id = 1
      country.unsubregion_id = 17
      country.save!
          
      country = Country.new
      country.id = 703
      country.name = "Slovakia"
      country.alpha2 = "SK"
      country.alpha3 = "SVK"
      country.unregion_id = 2
      country.unsubregion_id = 11
      country.save!
          
      country = Country.new
      country.id = 704
      country.name = "Viet Nam"
      country.alpha2 = "VN"
      country.alpha3 = "VNM"
      country.unregion_id = 1
      country.unsubregion_id = 17
      country.save!
          
      country = Country.new
      country.id = 705
      country.name = "Slovenia"
      country.alpha2 = "SI"
      country.alpha3 = "SVN"
      country.unregion_id = 2
      country.unsubregion_id = 2
      country.save!
          
      country = Country.new
      country.id = 706
      country.name = "Somalia"
      country.alpha2 = "SO"
      country.alpha3 = "SOM"
      country.unregion_id = 3
      country.unsubregion_id = 16
      country.save!
          
      country = Country.new
      country.id = 710
      country.name = "South Africa"
      country.alpha2 = "ZA"
      country.alpha3 = "ZAF"
      country.unregion_id = 3
      country.unsubregion_id = 15
      country.save!
          
      country = Country.new
      country.id = 716
      country.name = "Zimbabwe"
      country.alpha2 = "ZW"
      country.alpha3 = "ZWE"
      country.unregion_id = 3
      country.unsubregion_id = 16
      country.save!
          
      country = Country.new
      country.id = 724
      country.name = "Spain"
      country.alpha2 = "ES"
      country.alpha3 = "ESP"
      country.unregion_id = 2
      country.unsubregion_id = 2
      country.save!
          
      country = Country.new
      country.id = 732
      country.name = "Western Sahara"
      country.alpha2 = "EH"
      country.alpha3 = "ESH"
      country.unregion_id = 3
      country.unsubregion_id = 3
      country.save!
          
      country = Country.new
      country.id = 736
      country.name = "Sudan"
      country.alpha2 = "SD"
      country.alpha3 = "SDN"
      country.unregion_id = 3
      country.unsubregion_id = 3
      country.save!
          
      country = Country.new
      country.id = 740
      country.name = "Suriname"
      country.alpha2 = "SR"
      country.alpha3 = "SUR"
      country.unregion_id = 4
      country.unsubregion_id = 7
      country.save!
          
      country = Country.new
      country.id = 744
      country.name = "Svalbard And Jan Mayen"
      country.alpha2 = "SJ"
      country.alpha3 = "SJM"
      country.unregion_id = 2
      country.unsubregion_id = 19
      country.save!
          
      country = Country.new
      country.id = 748
      country.name = "Swaziland"
      country.alpha2 = "SZ"
      country.alpha3 = "SWZ"
      country.unregion_id = 3
      country.unsubregion_id = 15
      country.save!
          
      country = Country.new
      country.id = 752
      country.name = "Sweden"
      country.alpha2 = "SE"
      country.alpha3 = "SWE"
      country.unregion_id = 2
      country.unsubregion_id = 19
      country.save!
          
      country = Country.new
      country.id = 756
      country.name = "Switzerland"
      country.alpha2 = "CH"
      country.alpha3 = "CHE"
      country.unregion_id = 2
      country.unsubregion_id = 10
      country.save!
          
      country = Country.new
      country.id = 760
      country.name = "Syrian Arab Republic"
      country.alpha2 = "SY"
      country.alpha3 = "SYR"
      country.unregion_id = 1
      country.unsubregion_id = 8
      country.save!
          
      country = Country.new
      country.id = 762
      country.name = "Tajikistan"
      country.alpha2 = "TJ"
      country.alpha3 = "TJK"
      country.unregion_id = 1
      country.unsubregion_id = 22
      country.save!
          
      country = Country.new
      country.id = 764
      country.name = "Thailand"
      country.alpha2 = "TH"
      country.alpha3 = "THA"
      country.unregion_id = 1
      country.unsubregion_id = 17
      country.save!
          
      country = Country.new
      country.id = 768
      country.name = "Togo"
      country.alpha2 = "TG"
      country.alpha3 = "TGO"
      country.unregion_id = 3
      country.unsubregion_id = 13
      country.save!
          
      country = Country.new
      country.id = 772
      country.name = "Tokelau"
      country.alpha2 = "TK"
      country.alpha3 = "TKL"
      country.unregion_id = 4
      country.unsubregion_id = 4
      country.save!
          
      country = Country.new
      country.id = 776
      country.name = "Tonga"
      country.alpha2 = "TO"
      country.alpha3 = "TON"
      country.unregion_id = 4
      country.unsubregion_id = 4
      country.save!
          
      country = Country.new
      country.id = 780
      country.name = "Trinidad and Tobago"
      country.alpha2 = "TT"
      country.alpha3 = "TTO"
      country.unregion_id = 4
      country.unsubregion_id = 6
      country.save!
          
      country = Country.new
      country.id = 784
      country.name = "United Arab Emirates"
      country.alpha2 = "AE"
      country.alpha3 = "ARE"
      country.unregion_id = 1
      country.unsubregion_id = 8
      country.save!
          
      country = Country.new
      country.id = 788
      country.name = "Tunisia"
      country.alpha2 = "TN"
      country.alpha3 = "TUN"
      country.unregion_id = 3
      country.unsubregion_id = 3
      country.save!
          
      country = Country.new
      country.id = 792
      country.name = "Turkey"
      country.alpha2 = "TR"
      country.alpha3 = "TUR"
      country.unregion_id = 1
      country.unsubregion_id = 8
      country.save!
          
      country = Country.new
      country.id = 795
      country.name = "Turkmenistan"
      country.alpha2 = "TM"
      country.alpha3 = "TKM"
      country.unregion_id = 1
      country.unsubregion_id = 22
      country.save!
          
      country = Country.new
      country.id = 796
      country.name = "Turks and Caicos Islands"
      country.alpha2 = "TC"
      country.alpha3 = "TCA"
      country.unregion_id = 4
      country.unsubregion_id = 6
      country.save!
          
      country = Country.new
      country.id = 798
      country.name = "Tuvalu"
      country.alpha2 = "TV"
      country.alpha3 = "TUV"
      country.unregion_id = 4
      country.unsubregion_id = 4
      country.save!
          
      country = Country.new
      country.id = 800
      country.name = "Uganda"
      country.alpha2 = "UG"
      country.alpha3 = "UGA"
      country.unregion_id = 3
      country.unsubregion_id = 16
      country.save!
          
      country = Country.new
      country.id = 804
      country.name = "Ukraine"
      country.alpha2 = "UA"
      country.alpha3 = "UKR"
      country.unregion_id = 2
      country.unsubregion_id = 11
      country.save!
          
      country = Country.new
      country.id = 807
      country.name = "Macedonia, the Former Yugoslav Republic Of"
      country.alpha2 = "MK"
      country.alpha3 = "MKD"
      country.unregion_id = 2
      country.unsubregion_id = 2
      country.save!
          
      country = Country.new
      country.id = 818
      country.name = "Egypt"
      country.alpha2 = "EG"
      country.alpha3 = "EGY"
      country.unregion_id = 3
      country.unsubregion_id = 3
      country.save!
          
      country = Country.new
      country.id = 826
      country.name = "United Kingdom"
      country.alpha2 = "GB"
      country.alpha3 = "GBR"
      country.unregion_id = 2
      country.unsubregion_id = 19
      country.save!
          
      country = Country.new
      country.id = 831
      country.name = "Guernsey"
      country.alpha2 = "GG"
      country.alpha3 = "GGY"
      country.unregion_id = 2
      country.unsubregion_id = 19
      country.save!
          
      country = Country.new
      country.id = 832
      country.name = "Jersey"
      country.alpha2 = "JE"
      country.alpha3 = "JEY"
      country.unregion_id = 2
      country.unsubregion_id = 19
      country.save!
          
      country = Country.new
      country.id = 833
      country.name = "Isle of Man"
      country.alpha2 = "IM"
      country.alpha3 = "IMN"
      country.unregion_id = 2
      country.unsubregion_id = 19
      country.save!
          
      country = Country.new
      country.id = 834
      country.name = "Tanzania, United Republic of"
      country.alpha2 = "TZ"
      country.alpha3 = "TZA"
      country.unregion_id = 3
      country.unsubregion_id = 16
      country.save!
          
      country = Country.new
      country.id = 840
      country.name = "United States"
      country.alpha2 = "US"
      country.alpha3 = "USA"
      country.unregion_id = 4
      country.unsubregion_id = 14
      country.save!
          
      country = Country.new
      country.id = 850
      country.name = "Virgin Islands, U.S."
      country.alpha2 = "VI"
      country.alpha3 = "VIR"
      country.unregion_id = 4
      country.unsubregion_id = 6
      country.save!
          
      country = Country.new
      country.id = 854
      country.name = "Burkina Faso"
      country.alpha2 = "BF"
      country.alpha3 = "BFA"
      country.unregion_id = 3
      country.unsubregion_id = 13
      country.save!
          
      country = Country.new
      country.id = 858
      country.name = "Uruguay"
      country.alpha2 = "UY"
      country.alpha3 = "URY"
      country.unregion_id = 4
      country.unsubregion_id = 7
      country.save!
          
      country = Country.new
      country.id = 860
      country.name = "Uzbekistan"
      country.alpha2 = "UZ"
      country.alpha3 = "UZB"
      country.unregion_id = 1
      country.unsubregion_id = 22
      country.save!
          
      country = Country.new
      country.id = 862
      country.name = "Venezuela"
      country.alpha2 = "VE"
      country.alpha3 = "VEN"
      country.unregion_id = 4
      country.unsubregion_id = 7
      country.save!
          
      country = Country.new
      country.id = 876
      country.name = "Wallis and Futuna"
      country.alpha2 = "WF"
      country.alpha3 = "WLF"
      country.unregion_id = 4
      country.unsubregion_id = 4
      country.save!
          
      country = Country.new
      country.id = 882
      country.name = "Samoa"
      country.alpha2 = "WS"
      country.alpha3 = "WSM"
      country.unregion_id = 4
      country.unsubregion_id = 4
      country.save!
          
      country = Country.new
      country.id = 887
      country.name = "Yemen"
      country.alpha2 = "YE"
      country.alpha3 = "YEM"
      country.unregion_id = 1
      country.unsubregion_id = 8
      country.save!
          
      country = Country.new
      country.id = 894
      country.name = "Zambia"
      country.alpha2 = "ZM"
      country.alpha3 = "ZMB"
      country.unregion_id = 3
      country.unsubregion_id = 16
      country.save!

  end

  def self.down
    drop_table :countries
  end
end
