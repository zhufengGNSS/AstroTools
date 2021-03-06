stk.v.10.0
WrittenBy    STK_v10.1.3

BEGIN Planet

Name        Earth

BEGIN PathDescription

		CentralBody                    Earth
		UseCbEphemeris                 No

BEGIN               EphemerisData

	EphemerisSource             JplDE

	JplIndex                    2

	JplSpiceId                  399

	ApplyTDTtoTDBCorrectionForDE     Yes

      OrbitEpoch                  2451545.0000000
      OrbitMeanDist               149597886455.77
      OrbitEcc                    0.016710220000000
      OrbitInc                    23.439340817682
      OrbitRAAN                   359.99996261497
      OrbitPerLong                462.94718913084
      OrbitMeanLong               820.46434913084
      OrbitMeanDistDot            -0.20478832306639
      OrbitEccDot                 -1.0414784394251e-009
      OrbitIncDot                 -3.5013667765779e-007
      OrbitRAANDot                1.7494818152532e-007
      OrbitPerLongDot             9.1275248714004e-006
      OrbitMeanLongDot            0.98560911497639

END     EphemerisData

END PathDescription

	BEGIN PhysicalData

		GM                   3.986004418000e+014
		Radius               6.378137000000e+006
		Magnitude            0.000000000000e+000
		ReferenceDistance    0.000000000000e+000

	END PhysicalData

	BEGIN AutoRename

		AutoRename           Yes

	END AutoRename

BEGIN Extensions
    
    BEGIN Graphics

			BEGIN Attributes

				MarkerColor             #00ffff
				LabelColor              #00ffff
				LineColor               #00ffff
				LineStyle               0
				LineWidth               1.0
				MarkerStyle             2
				FontStyle               0

			END Attributes

			BEGIN Graphics

				Show                     On
				Inherit                  On
				ShowLabel                On
				ShowPlanetPoint          On
				ShowSubPlanetPoint       Off
				ShowSubPlanetLabel       Off
				ShowOrbit                On
				NumOrbitPoints           360
				OrbitTime                3.152393155701e+007
				OrbitDisplay             OneOrbit
				TransformTrajectory      On

			END Graphics
    END Graphics
    
    BEGIN ExternData
    END ExternData
    
    BEGIN ADFFileData
    END ADFFileData
    
    BEGIN AccessConstraints
		LineOfSight   IncludeIntervals 
    END AccessConstraints
    
    BEGIN Desc
    END Desc
    
    BEGIN Crdn
    END Crdn
    
    BEGIN VO
    END VO

END Extensions

END Planet

