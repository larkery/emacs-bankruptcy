(require 'sql)
(require 'subr-x)

(defcustom
  sql-spatialite-program (or (executable-find "spatialite")
                             "spatialite")
  "The spatialite command"
  :group 'SQL)

(defcustom
  sql-spatialite-options nil
  "Arguments to the spatialite command"
  :type '(repeat string)
  :group 'SQL)

(defcustom
  sql-spatialite-login-params '((database :file ".*\\.\\(db\\|sqlite[23]?\\)"))
  "Login paramters to spatialite"
  :type 'sql-login-params
  :group 'SQL)

(defun sql-comint-spatialite (product options)
  "This is very similar to `sql-comint-sqlite', except it also
works when the database is a TRAMP remote path"
  (let ((params
         (append options
                 (cond
                  ((string= "" sql-database)
                   nil)
                  ((file-remote-p sql-database)
                   (list (tramp-file-name-localname
                          (tramp-dissect-file-name sql-database))))
                  (t (list (expand-file-name sql-database)))))))
    (sql-comint product params)))

(defvar spatialite-syntax
  (eval-when-compile
    (require 'subr-x)
    (let ((spatialite-syntax (make-hash-table :test 'equal)))
      (with-temp-buffer
        ;; xidel spatialite-sql-4.3.0.html --extract '//tr/td[position()=2]' | perl -0777 -nle \
        ;; 'while (m/\s*(\w+\(.+?\)( : [A-za-z ]+)?)/sg) {
        ;;   print $1 =~ s/[\n\t ]+/ /gr, "\n";
        ;; }'|xclip
        (insert
         ".backup DB FILE
.bail ON | OFF
.databases
.dump TABLE
.echo ON | OFF
.exit
.explain ON | OFF
.header ON | OFF
.help
.import FILE TABLE
.indices TABLE
.load FILE ENTRY
.log FILE|off
.mode csv|column|html|insert|line|list|tabs|tcl TABLE
.nullvalue STRING
.output FILENAME | stdout
.prompt MAIN CONTINUE
.quit
.read FILENAME
.restore DB FILE
.schema TABLE
.separator STRING
.show
.stats ON | OFF
.tables TABLE
.timeout MS
.trace FILE | off
.vfsname AUX
.width NUM1 NUM2 ...
.timer ON | OFF
.charset [charset-name]
.chkdupl table
.remdupl table
.elemgeo table
.loadshp shp_path table_name charset [SRID] [column_name] [pk_column] [geom_type] [2d | 3d] [compressed] [with_spatial_index]
.dumpshp table_name shp_path charset [geom_type]
.loaddbf dbf_path table_name charset [pk_column]
.dumpdbf table_name dbf_path charset
.dumpkml table_name geom_column kml_path [precision] [name_column] [desc_column]
.dumpgeojson table_name geom_column geojson_path [format] [precision]
.checkgeom table_name geom_column report_path | output_dir
.sanegeom table_name geom_column tmp_table report_path | tmp_prefix output_dir
.sqllog ON | OFF
.dropgeo table
.loadwfs WFS_path_or_URL layer_name table_name [pk_column] [swap] [page_size] [with_spatial_index]
.loaddxf DXF_path [srid] [append] [dims] [mode] [rings] [table_prefix] [layer_name]
"
         )
        (insert
"abs( X Number ) : Number
changes()
char( X1,X2,...,XN ) : Text
coalesce( X,Y,... ) : Generic
glob(X,Y) : Text
hex(X)
ifnull(X,Y)
instr(X,Y)
last_insert_rowid()
length(X)
like(X,Y)
like(X,Y,Z)
likelihood(X,Y)
likely(X)
load_extension(X)
load_extension(X,Y)
lower(X)
ltrim(X)
ltrim(X,Y)
max(X,Y,...)
min(X,Y,...)
nullif(X,Y)
printf(FORMAT,...)
quote(X)
random()
randomblob(N)
replace(X,Y,Z)
round(X)
round(X,Y)
rtrim(X)
rtrim(X,Y)
soundex(X)
sqlite_compileoption_get(N)
sqlite_compileoption_used(X)
sqlite_source_id()
sqlite_version()
substr(X,Y)
substr(X,Y,Z)
total_changes()
trim(X)
trim(X,Y)
typeof(X)
unicode(X)
unlikely(X)
upper(X)
zeroblob(N)
time( timestring, modifier, modifier, ... )
date( timestring, modifier, modifier, ... )
datetime( timestring, modifier, modifier, ... )
julianday( timestring, modifier, modifier, ... )
strftime( format, timestring, modifier, modifier, ... )
avg( X )
count( X | * )
group_concat( X )
group_concat( X, Y )
max( X )
min( X )
sum( X )
total( X )
")
        (insert
         "spatialite_version( void ) : String
spatialite_target_cpu( void ) : String
freexl_version( void ) : String
proj4_version( void ) : String
geos_version( void ) : String
lwgeom_version( void ) : String
libxml2_version( void ) : String
HasIconv( void ) : Boolean
HasMathSQL( void ) : Boolean
HasGeoCallbacks( void ) : Boolean
HasProj( void ) : Boolean
HasGeos( void ) : Boolean
HasGeosAdvanced( void ) : Boolean
HasGeosTrunk( void ) : Boolean
HasLwGeom( void ) : Boolean
HasLibXML2( void ) : Boolean
HasEpsg( void ) : Boolean
HasFreeXL( void ) : Boolean
HasGeoPackage( void ) : Boolean
CastToInteger( value Generic ) : Integer
CastToDouble( value Generic ) : Double precision
CastToText( value Generic ) : Text
CastToText( value Generic , zero_pad Integer ) : Text
CastToBlob( value Generic ) : Blob
CastToBlob( value Generic , hex_input Boolean ) : Blob
ForceAsNull( val1 Generic , val2 Generic) : Generic
CreateUUID( void ) : Text
MD5Checksum( BLOB | TEXT ) : Text
MD5TotalChecksum( BLOB | TEXT ) : Text
EncodeURL( TEXT ) : Text
DecodeURL( TEXT ) : Text
DirNameFromPath( TEXT ) : Text
FullFileNameFromPath( TEXT ) : Text
FileNameFromPath( TEXT ) : Text
FileExtFromPath( TEXT ) : Text
eval( X TEXT [ , Y TEXT ) : Text
EnableGpkgMode( void ) : void
DisableGpkgMode( void ) : void
GetGpkgMode( void ) : boolean
EnableGpkgAmphibiousMode( void ) : void
DisableGpkgAmphibiousMode( void ) : void
GetGpkgAmphibiousMode( void ) : boolean
SetDecimalPrecision( integer ) : void
GetDecimalPrecision( void ) : integer
Abs( x Double precision ) : Double precision
Acos( x Double precision ) : Double precision
Asin( x Double precision ) : Double precision
Atan( x Double precision ) : Double precision
Atan2( y Double precision , x Double precision ) : Double precision
Ceil( x Double precision ) : Double precision
Ceiling( x Double precision ) : Double precision
Cos( x Double precision ) : Double precision
Cot( x Double precision ) : Double precision
Degrees( x Double precision ) : Double precision
Exp( x Double precision ) : Double precision
Floor( x Double precision ) : Double precision
Ln( x Double precision ) : Double precision
Log( x Double precision ) : Double precision
Log( b Double precision , x Double precision ) : Double precision
Log2( x Double precision ) : Double precision
Log10( x Double precision ) : Double precision
PI( void ) : Double precision
Pow( x Double precision , y Double precision ) : Double precision
Power( x Double precision , y Double precision ) : Double precision
Radians( x Double precision ) : Double precision
Sign( x Double precision ) : Double precision
Sin( x Double precision ) : Double precision
Sqrt( x Double precision ) : Double precision
Stddev_pop( x Double precision ) : Double precision
Stddev_samp( x Double precision ) : Double precision
Tan( x Double precision ) : Double precision
Var_pop( x Double precision ) : Double precision
Var_samp( x Double precision ) : Double precision
GEOS_GetLastWarningMsg( void ) : String
GEOS_GetLastErrorMsg( void ) : String
GEOS_GetLastAuxErrorMsg( void ) : String
GEOS_GetCriticalPointFromMsg( void ) : Point
GEOS_GetCriticalPointFromMsg( SRID Integer ) : Point
LWGEOM_GetLastWarningMsg( void ) : String
LWGEOM_GetLastErrorMsg( void ) : String
CvtToKm( x Double precision ) : Double precision
CvtFromKm( x Double precision ) : Double precision
CvtToDm( x Double precision ) : Double precision
CvtFromDm( x Double precision ) : Double precision
CvtToCm( x Double precision ) : Double precision
CvtFromCm( x Double precision ) : Double precision
CvtToMm( x Double precision ) : Double precision
CvtFromMm( x Double precision ) : Double precision
CvtToKmi( x Double precision ) : Double precision
CvtFromKmi( x Double precision ) : Double precision
CvtToIn( x Double precision ) : Double precision
CvtFromIn( x Double precision ) : Double precision
CvtToFt( x Double precision ) : Double precision
CvtFromFt( x Double precision ) : Double precision
CvtToYd( x Double precision ) : Double precision
CvtFromYd( x Double precision ) : Double precision
CvtToMi( x Double precision ) : Double precision
CvtFromMi( x Double precision ) : Double precision
CvtToFath( x Double precision ) : Double precision
CvtFromFath( x Double precision ) : Double precision
CvtToCh( x Double precision ) : Double precision
CvtFromCh( x Double precision ) : Double precision
CvtToLink( x Double precision ) : Double precision
CvtFromLink( x Double precision ) : Double precision
CvtToUsIn( x Double precision ) : Double precision
CvtFromUsIn( x Double precision ) : Double precision
CvtToUsFt( x Double precision ) : Double precision
CvtFromUsFt( x Double precision ) : Double precision
CvtToUsYd( x Double precision ) : Double precision
CvtFromUsYd( x Double precision ) : Double precision
CvtToUsMi( x Double precision ) : Double precision
CvtFromUsMi( x Double precision ) : Double precision
CvtToUsCh( x Double precision ) : Double precision
CvtFromUsCh( x Double precision ) : Double precision
CvtToIndFt( x Double precision ) : Double precision
CvtFromIndFt( x Double precision ) : Double precision
CvtToIndYd( x Double precision ) : Double precision
CvtFromIndYd( x Double precision ) : Double precision
CvtToIndCh( x Double precision ) : Double precision
CvtFromIndCh( x Double precision ) : Double precision
LongLatToDMS( longitude Double precision , latitude Double precision ) : String
LongitudeFromDMS( dms_expression Sting ) : Double precision
LatitudeFromDMS( dms_expression Sting ) : Double precision
IsZipBlob( content BLOB ) : Integer
IsPdfBlob( content BLOB ) : Integer
IsGifBlob( image BLOB ) : Integer
IsPngBlob( image BLOB ) : Integer
IsTiffBlob( image BLOB ) : Integer
IsJpegBlob( image BLOB ) : Integer
IsExifBlob( image BLOB ) : Integer
IsExifGpsBlob( image BLOB ) : Integer
IsWebpBlob( image BLOB ) : Integer
IsJP2Blob( image BLOB ) : Integer
GetMimeType( payload BLOB ) : String
BlobFromFile( filepath String ) : BLOB
BlobToFile( payload BLOB , filepath String ) : Integer
CountUnsafeTriggers( ) : Integer
GeomFromExifGpsBlob( image BLOB ) : Geometry
ST_Point( x Double precision , y Double precision ) : Geometry
MakePoint( x Double precision , y Double precision , [ , SRID Integer] ) : Geometry
MakePointZ( x Double precision , y Double precision , z Double precision , [ , SRID Integer] ) : Geometry
MakePointM( x Double precision , y Double precision , m Double precision , [ , SRID Integer] ) : Geometry
MakePointZM( x Double precision , y Double precision , z Double precision , m Double precision [ , SRID Integer] ) : Geometry
MakeLine( pt1 PointGeometry , pt2 PointGeometry ) : LinestringGeometry
MakeLine( geom PointGeometry ) : LinestringGeometry
MakeLine( geom MultiPointGeometry , direction Boolean ) : LinestringGeometry
MakeCircle( cx Double precision , cy Double precision , radius Double precision [ , SRID Integer [ , step Double precision ] ] ) : Geometry
MakeEllipse( cx Double precision , cy Double precision , x_axis Double precision , y_axis Double precisin [ , SRID Integer [ , step Double precision ] ] ) : Geometry
MakeArc( cx Double precision , cy Double precision , radius Double precision , start Double precision , stop Double precision [ , SRID Integer [ , step Double precision ] ] ) : Geometry
MakeEllipticArc( cx Double precision , cy Double precision , x_axis Double precision , y_axis Double precision , start Double precision , stop Double precision [ , SRID Integer [ , step Double precision ] ] ) : Geometry
MakeCircularSector( cx Double precision , cy Double precision , radius Double precision , start Double precision , stop Double precision [ , SRID Integer [ , step Double precision ] ] ) : Geometry
MakeEllipticSector( cx Double precision , cy Double precision , x_axis Double precision , y_axis Double precision , start Double precision , stop Double precision [ , SRID Integer [ , step Double precision ] ] ) : Geometry
MakeCircularStripe( cx Double precision , cy Double precision , radius_1 Double precision , radius_2 Double precision , start Double precision , stop Double precision [ , SRID Integer [ , step Double precision ] ] ) : Geometry
SquareGrid( geom ArealGeometry , size Double precision [ , edges_only Boolean , [ origing PointGeometry ] ] ) : Geometry
ST_SquareGrid( geom ArealGeometry , size Double precision [ , edges_only Boolean , [ origing PointGeometry ] ] ) : Geometry
TriangularGrid( geom ArealGeometry , size Double precision [ , edges_only Boolean , [ origing PointGeometry ] ] ) : Geometry
ST_TriangularGrid( geom ArealGeometry , size Double precision [ , edges_only Boolean , [ origing PointGeometry ] ] ) : Geometry
HexagonalGrid( geom ArealGeometry , size Double precision [ , edges_only Boolean , [ origing PointGeometry ] ] ) : Geometry
ST_HexagonalGrid( geom ArealGeometry , size Double precision [ , edges_only Boolean , [ origing PointGeometry ] ] ) : Geometry
BuildMbr( x1 Double precision , y1 Double precision , x2 Double precision , y2 Double precision [ , SRID Integer] ) : Geometry
BuildCircleMbr( x Double precision , y Double precision , radius Double precision [ , SRID Integer] ) : Geometry
Extent( geom Geometry ) : Geometry
ToGARS( geom Geometry ) : String
GARSMbr( code String ) : Geometry
MbrMinX( geom Geometry) : Double precision
ST_MinX( geom Geometry) : Double precision
MbrMinY( geom Geometry) : Double precision
ST_MinY( geom Geometry) : Double precision
MbrMaxX( geom Geometry) : Double precision
ST_MaxX( geom Geometry) : Double precision
MbrMaxY( geom Geometry) : Double precision
ST_MaxY( geom Geometry) : Double precision
ST_MinZ( geom Geometry) : Double precision
ST_MaxZ( geom Geometry) : Double precision
ST_MinM( geom Geometry) : Double precision
ST_MaxM( geom Geometry) : Double precision
GeomFromText( wkt String [ , SRID Integer] ) : Geometry
ST_GeomFromText( wkt String [ , SRID Integer] ) : Geometry
ST_WKTToSQL( wkt String ) : Geometry
PointFromText( wktPoint String [ , SRID Integer] ) : Point
ST_PointFromText( wktPoint String [ , SRID Integer] ) : Point
LineFromText( wktLineString String [ , SRID Integer] ) : Linestring
ST_LineFromText( wktLineString String [ , SRID Integer] ) : Linestring
LineStringFromText( wktLineString String [ , SRID Integer] ) : Linestring
ST_LineStringFromText( wktLineString String [ , SRID Integer] ) : Linestring
PolyFromText( wktPolygon String [ , SRID Integer] ) : Polygon
ST_PolyFromText( wktPolygon String [ , SRID Integer] ) : Polygon
PolygonFromText( wktPolygon String [ , SRID Integer] ) : Polygon
ST_PolygonFromText( wktPolygon String [ , SRID Integer] ) : Polygon
MPointFromText( wktMultiPoint String [ , SRID Integer] ) : MultiPoint
ST_MPointFromText( wktMultiPoint String [ , SRID Integer] ) : MultiPoint
MultiPointFromText( wktMultiPoint String [ , SRID Integer] ) : MultiPoint
ST_MultiPointFromText( wktMultiPoint String [ , SRID Integer] ) : MultiPoint
MLineFromText( wktMultiLineString String [ , SRID Integer] ) : MultiLinestring
ST_MLineFromText( wktMultiLineString String [ , SRID Integer] ) : MultiLinestring
MultiLineStringFromText( wktMultiLineString String [ , SRID Integer] ) : MultiLinestring
ST_MultiLineStringFromText( wktMultiLineString String [ , SRID Integer] ) : MultiLinestring
MPolyFromText( wktMultiPolygon String [ , SRID Integer] ) : MultiPolygon
ST_MPolyFromText( wktMultiPolygon String [ , SRID Integer] ) : MultiPolygon
MultiPolygonFromText( wktMultiPolygon String [ , SRID Integer] ) : MultiPolygon
ST_MultiPolygonFromText( wktMultiPolygon String [ , SRID Integer] ) : MultiPolygon
GeomCollFromText( wktGeometryCollection String [ , SRID Integer] ) : GeometryCollection
ST_GeomCollFromText( wktGeometryCollection String [ , SRID Integer] ) : GeometryCollection
GeometryCollectionFromText( wktGeometryCollection String [ , SRID Integer] ) : GeometryCollection
ST_GeometryCollectionFromText( wktGeometryCollection String [ , SRID Integer] ) : GeometryCollection
BdPolyFromText( wktMultilinestring String [ , SRID Integer] ) : Polygon
ST_BdPolyFromText( wktMultilinestring String [ , SRID Integer] ) : Polygon
BdMPolyFromText( wktMultilinestring String [ , SRID Integer] ) : MultiPolygon
ST_BdMPolyFromText( wktMultilinestring String [ , SRID Integer] ) : MultiPolygon
GeomFromWKB( wkbGeometry Binary [ , SRID Integer] ) : Geometry
ST_GeomFromWKB( wkbGeometry Binary [ , SRID Integer] ) : Geometry
ST_WKBToSQL( wkbGeometry Binary ) : Geometry
PointFromWKB( wkbPoint Binary [ , SRID Integer] ) : Point
ST_PointFromWKB( wkbPoint Binary [ , SRID Integer] ) : Point
LineFromWKB( wkbLineString Binary [ , SRID Integer] ) : Linestring
ST_LineFromWKB( wkbLineString Binary [ , SRID Integer] ) : Linestring
LineStringFromText( wkbLineString Binary [ , SRID Integer] ) : Linestring
ST_LineStringFromText( wkbLineString Binary [ , SRID Integer] ) : Linestring
PolyFromWKB( wkbPolygon Binary [ , SRID Integer] ) : Polygon
ST_PolyFromWKB( wkbPolygon Binary [ , SRID Integer] ) : Polygon
PolygonFromWKB( wkbPolygon Binary [ , SRID Integer] ) : Polygon
ST_PolygonFromWKB( wkbPolygon Binary [ , SRID Integer] ) : Polygon
MPointFromWKB( wkbMultiPoint Binary [ , SRID Integer] ) : MultiPoint
ST_MPointFromWKB( wkbMultiPoint Binary [ , SRID Integer] ) : MultiPoint
MultiPointFromWKB( wkbMultiPoint Binary [ , SRID Integer] ) : MultiPoint
ST_MultiPointFromWKB( wkbMultiPoint Binary [ , SRID Integer] ) : MultiPoint
MLineFromWKB( wkbMultiLineString Binary [ , SRID Integer] ) : MultiLinestring
ST_MLineFromWKB( wkbMultiLineString Binary [ , SRID Integer] ) : MultiLinestring
MultiLineStringFromWKB( wkbMultiLineString Binary [ , SRID Integer] ) : MultiLinestring
ST_MultiLineStringFromWKB( wkbMultiLineString Binary [ , SRID Integer] ) : MultiLinestring
MPolyFromWKB( wkbMultiPolygon Binary [ , SRID Integer] ) : MultiPolygon
ST_MPolyFromWKB( wkbMultiPolygon Binary [ , SRID Integer] ) : MultiPolygon
MultiPolygonFromWKB( wkbMultiPolygon Binary [ , SRID Integer] ) : MultiPolygon
ST_MultiPolygonFromWKB( wkbMultiPolygon Binary [ , SRID Integer] ) : MultiPolygon
GeomCollFromWKB( wkbGeometryCollection Binary [ , SRID Integer] ) : GeometryCollection
ST_GeomCollFromWKB( wkbGeometryCollection Binary [ , SRID Integer] ) : GeometryCollection
GeometryCollectionFromWKB( wkbGeometryCollection Binary [ , SRID Integer] ) : GeometryCollection
ST_GeometryCollectionFromWKB( wkbGeometryCollection Binary [ , SRID Integer] ) : GeometryCollection
BdPolyFromWKB( wkbMultilinestring Binary [ , SRID Integer] ) : Polygon
ST_BdPolyFromWKB( wkbMultilinestring Binary [ , SRID Integer] ) : Polygon
BdMPolyFromWKB( wkbMultilinestring Binary [ , SRID Integer] ) : MultiPolygon
ST_BdMPolyFromWKB( wkbMultilinestring Binary [ , SRID Integer] ) : MultiPolygon
AsText( geom Geometry ) : String
ST_AsText( geom Geometry ) : String
AsWKT( geom Geometry [ , precision Integer ] ) : String
AsBinary( geom Geometry ) : Binary
ST_AsBinary( geom Geometry ) : Binary
AsSVG( geom Geometry [ , relative Integer [ , precision Integer ] ] ) : String
AsKml( geom Geometry [ , precision Integer ] ) : String
AsKml( name String, description String, geom Geometry [ , precision Integer ] ) : String
GeomFromKml( KmlGeometry String ) : Geometry
AsGml( geom Geometry [ , precision Integer ] ) : String
AsGml( version Integer, geom Geometry [ , precision Integer ] ) : String
GeomFromGML( gmlGeometry String ) : Geometry
AsGeoJSON( geom Geometry [ , precision Integer [ , options Integer ] ] ) : String
GeomFromGeoJSON( geoJSONGeometry String ) : Geometry
AsEWKB( geom Geometry ) : String
GeomFromEWKB( ewkbGeometry String ) : Geometry
AsEWKT( geom Geometry ) : String
GeomFromEWKT( ewktGeometry String ) : Geometry
AsFGF( geom Geometry ) : Binary
GeomFromFGF( fgfGeometry Binary [ , SRID Integer] ) : Geometry
Dimension( geom Geometry ) : Integer
ST_Dimension( geom Geometry ) : Integer
CoordDimension( geom Geometry ) : String
ST_NDims( geom Geometry ) : Integer
ST_Is3D( geom Geometry ) : Integer
ST_IsMeasured( geom Geometry ) : Integer
GeometryType( geom Geometry ) : String
ST_GeometryType( geom Geometry ) : String
SRID( geom Geometry ) : Integer
ST_SRID( geom Geometry ) : Integer
SetSRID( geom Geometry , SRID Integer ) : Integer
IsEmpty( geom Geometry ) : Integer
ST_IsEmpty( geom Geometry ) : Integer
IsSimple( geom Geometry ) : Integer
ST_IsSimple( geom Geometry ) : Integer
IsValid( geom Geometry ) : Integer
ST_IsValid( geom Geometry ) : Integer
IsValidReason( geom Geometry ) : String
ST_IsValidReason( geom Geometry ) : String
IsValidDetail( geom Geometry ) : Geometry
ST_IsValidDetail( geom Geometry ) : Geometry
Boundary( geom Geometry ) : Geometry
ST_Boundary( geom Geometry ) : Geometry
Envelope( geom Geometry ) : Geometry
ST_Envelope( geom Geometry ) : Geometry
ST_Expand( geom Geometry , amount Double precision ) : Geometry
ST_NPoints( geom Geometry ) : Integer
ST_NRings( geom Geometry ) : Integer
ST_Reverse( geom Geometry ) : Geometry
ST_ForceLHR( geom Geometry ) : Geometry
SanitizeGeometry( geom Geometry ) : geom Geometry
CompressGeometry( geom Geometry ) : geom Geometry
UncompressGeometry( geom Geometry ) : geom Geometry
CastToPoint( geom Geometry ) : geom Geometry
CastToLinestring( geom Geometry ) : geom Geometry
CastToPolygon( geom Geometry ) : geom Geometry
CastToMultiPoint( geom Geometry ) : geom Geometry
CastToMultiLinestring( geom Geometry ) : geom Geometry
CastToMultiPolygon( geom Geometry ) : geom Geometry
CastToGeometryCollection( geom Geometry ) : geom Geometry
CastToMulti( geom Geometry ) : geom Geometry
ST_Multi( geom Geometry ) : geom Geometry
CastToSingle( geom Geometry ) : geom Geometry
CastToXY( geom Geometry ) : geom Geometry
CastToXYZ( geom Geometry ) : geom Geometry
CastToXYM( geom Geometry ) : geom Geometry
CastToXYZM( geom Geometry ) : geom Geometry
X( pt Point ) : Double precision
ST_X( pt Point ) : Double precision
Y( pt Point ) : Double precision
ST_Y( pt Point ) : Double precision
Z( pt Point ) : Double precision
ST_Z( pt Point ) : Double precision
M( pt Point ) : Double precision
ST_M( pt Point ) : Double precision
StartPoint( c Curve ) : Point
ST_StartPoint( c Curve ) : Point
EndPoint( c Curve ) : Point
ST_EndPoint( c Curve ) : Point
GLength( c Curve ) : Double precision
Length(), but it conflicts with an SQLite reserved keyword ST_Length( c Curve ) : Double precision
Perimeter( s Surface ) : Double precision
ST_Perimeter( s Surface ) : Double precision
GeodesicLength( c Curve ) : Double precision
GreatCircleLength( c Curve ) : Double precision
IsClosed( c Curve ) : Integer
ST_IsClosed( c Curve ) : Integer
IsRing( c Curve ) : Integer
ST_IsRing( c Curve ) : Integer
PointOnSurface( s Surface/Curve ) : Point
ST_PointOnSurface( s Surface/Curve ) : Point
Simplify( c Curve , tolerance Double precision ) : Curve
ST_Simplify( c Curve , tolerance Double precision ) : Curve
ST_Generalize( c Curve , tolerance Double precision ) : Curve
SimplifyPreserveTopology( c Curve , tolerance Double precision ) : Curve
ST_SimplifyPreserveTopology( c Curve , tolerance Double precision ) : Curve
NumPoints( line LineString ) : Integer
ST_NumPoints( line LineString ) : Integer
PointN( line LineString , n Integer ) : Point
ST_PointN( line LineString , n Integer ) : Point
AddPoint( line LineString , point Point [ , position Integer ] ) : Linestring
ST_AddPoint( line LineString , point Point [ , position Integer ] ) : Linestring
SetPoint( line LineString , position Integer , point Point ) : Linestring
ST_SetPoint( line LineString , position Integer , point Point ) : Linestring
SetStartPoint( line LineString , point Point ) : Linestring
ST_SetStartPoint( line LineString , point Point ) : Linestring
SetEndPoint( line LineString , point Point ) : Linestring
ST_SetEndPoint( line LineString , point Point ) : Linestring
RemovePoint( line LineString , position Integer ) : Linestring
ST_RemovePoint( line LineString , position Integer ) : Linestring
Centroid( s Surface ) : Point
ST_Centroid( s Surface ) : Point
Area( s Surface ) : Double precision
ST_Area( s Surface ) : Double precision
ExteriorRing( polyg Polygon ) : LineString
ST_ExteriorRing( polyg Polygon ) : LineString
NumInteriorRing( polyg Polygon ) : Integer
NumInteriorRings( polyg Polygon ) : Integer
ST_NumInteriorRing( polyg Polygon ) : Integer
InteriorRingN( polyg Polygon , n Integer ) : LineString
ST_InteriorRingN( polyg Polygon , n Integer ) : LineString
NumGeometries( geom GeomCollection ) : Integer
ST_NumGeometries( geom GeomCollection ) : Integer
GeometryN( geom GeomCollection , n Integer ) : Geometry
ST_GeometryN( geom GeomCollection , n Integer ) : Geometry
MbrEqual( geom1 Geometry , geom2 Geometry ) : Integer
MbrDisjoint( geom1 Geometry , geom2 Geometry ) : Integer
MbrTouches( geom1 Geometry , geom2 Geometry ) : Integer
MbrWithin( geom1 Geometry , geom2 Geometry ) : Integer
MbrOverlaps( geom1 Geometry , geom2 Geometry ) : Integer
MbrIntersects( geom1 Geometry , geom2 Geometry ) : Integer
ST_EnvIntersects( geom1 Geometry , geom2 Geometry ) : Integer
ST_EnvelopesIntersects( geom1 Geometry , geom2 Geometry ) : Integer
ST_EnvIntersects( geom1 Geometry , x1 Double precision , y1 Double precision , x2 Double precision , y2 Double precision ) : Integer
ST_EnvelopesIntersects( geom1 Geometry , x1 Double precision , y1 Double precision , x2 Double precision , y2 Double precision ) : Integer
MbrContains( geom1 Geometry , geom2 Geometry ) : Integer
Equals( geom1 Geometry , geom2 Geometry ) : Integer
ST_Equals( geom1 Geometry , geom2 Geometry ) : Integer
Disjoint( geom1 Geometry , geom2 Geometry ) : Integer
ST_Disjoint( geom1 Geometry , geom2 Geometry ) : Integer
Touches( geom1 Geometry , geom2 Geometry ) : Integer
ST_Touches( geom1 Geometry , geom2 Geometry ) : Integer
Within( geom1 Geometry , geom2 Geometry ) : Integer
ST_Within( geom1 Geometry , geom2 Geometry ) : Integer
Overlaps( geom1 Geometry , geom2 Geometry ) : Integer
ST_Overlaps( geom1 Geometry , geom2 Geometry ) : Integer
Crosses( geom1 Geometry , geom2 Geometry ) : Integer
ST_Crosses( geom1 Geometry , geom2 Geometry ) : Integer
Intersects( geom1 Geometry , geom2 Geometry ) : Integer
ST_Intersects( geom1 Geometry , geom2 Geometry ) : Integer
Contains( geom1 Geometry , geom2 Geometry ) : Integer
ST_Contains( geom1 Geometry , geom2 Geometry ) : Integer
Covers( geom1 Geometry , geom2 Geometry ) : Integer
ST_Covers( geom1 Geometry , geom2 Geometry ) : Integer
CoveredBy( geom1 Geometry , geom2 Geometry ) : Integer
ST_CoveredBy( geom1 Geometry , geom2 Geometry ) : Integer
Relate( geom1 Geometry , geom2 Geometry , patternMatrix String ) : Integer
ST_Relate( geom1 Geometry , geom2 Geometry , patternMatrix String ) : Integer
Distance( geom1 Geometry , geom2 Geometry ) : Double precision
ST_Distance( geom1 Geometry , geom2 Geometry ) : Double precision
PtDistWithin( geom1 Geometry , geom2 Geometry, range Double precision [, use_spheroid Integer ] )
Intersection( geom1 Geometry , geom2 Geometry ) : Geometry
ST_Intersection( geom1 Geometry , geom2 Geometry ) : Geometry
Difference( geom1 Geometry , geom2 Geometry ) : Geometry
ST_Difference( geom1 Geometry , geom2 Geometry ) : Geometry
GUnion( geom1 Geometry , geom2 Geometry ) : Geometry
Union(), but it conflicts with an SQLite reserved keyword ST_Union( geom1 Geometry , geom2 Geometry ) : Geometry
GUnion( geom Geometry ) : Geometry
ST_Union( geom Geometry ) : Geometry
SymDifference( geom1 Geometry , geom2 Geometry ) : Geometry
ST_SymDifference( geom1 Geometry , geom2 Geometry ) : Geometry
Buffer( geom Geometry , dist Double precision [ , quadrantsegments Integer ] ) : Geometry
ST_Buffer( geom Geometry , dist Double precision [ , quadrantsegments Integer ] ) : Geometry
ConvexHull( geom Geometry ) : Geometry
ST_ConvexHull( geom Geometry ) : Geometry
HausdorffDistance( geom1 Geometry , geom2 Geometry ) : Double precision
ST_HausdorffDistance( geom1 Geometry , geom2 Geometry ) : Double precision
OffsetCurve( geom Curve , radius Double precision ) : Curve
ST_OffsetCurve( geom Curve , radius Double precision ) : Curve
SingleSidedBuffer( geom Curve , radius Double precision , left_or_right Integer ) : Curve
ST_SingleSidedBuffer( geom Curve , radius Double precision , left_or_right Integer ) : Curve
SharedPaths( geom1 Geometry , geom2 Geomety ) : Geometry
ST_SharedPaths( geom1 Geometry , geom2 Geomety ) : Geometry
Line_Interpolate_Point( line Curve , fraction Double precision ) : Point
ST_Line_Interpolate_Point( line Curve , fraction Double precision ) : Point
Line_Interpolate_Equidistant_Points( line Curve , distance Double precision) : MultiPoint
ST_Line_Interpolate_Equidistant_Points( line Curve , distance Double precision ) : MultiPoint
Line_Locate_Point( line Curve , point Point ) : Double precision
ST_Line_Locate_Point( line Curve , point Point ) : Double precision
Line_Substring( line Curve , start_fraction Double precision , end_fraction Double precision ) : Curve
ST_Line_Substring( line Curve , start_fraction Double precision , end_fraction Double precision ) : Curve
ClosestPoint( geom1 Geometry , geom2 Geometry ) : Point
ST_ClosestPoint( geom1 Geometry , geom2 Geometry ) : Point
ShortestLine( geom1 Geometry , geom2 Geometry ) : Curve
ST_ShortestLine( geom1 Geometry , geom2 Geometry ) : Curve
Snap( geom1 Geometry , geom2 Geometry , tolerance Double precision ) : Geometry
ST_Snap( geom1 Geometry , geom2 Geometry , tolerance Double precision ) : Geometry
Collect( geom1 Geometry , geom2 Geometry ) : Geometry
ST_Collect( geom1 Geometry , geom2 Geometry ) : Geometry
Collect( geom Geometry ) : Geometry
ST_Collect( geom Geometry ) : Geometry
LineMerge( geom Geometry ) : Geometry
ST_LineMerge( geom Geometry ) : Geometry
BuildArea( geom Geometry ) : Geometry
ST_BuildArea( geom Geometry ) : Geometry
Polygonize( geom Geometry ) : Geometry
ST_Polygonize( geom Geometry ) : Geometry
MakePolygon( geom1 Geometry [ , geom2 Geometry ] ) : Geometry
ST_MakePolygon( geom1 Geometry [ , geom2 Geometry ] ) : Geometry
UnaryUnion( geom Geometry ) : Geometry
ST_UnaryUnion( geom Geometry ) : Geometry
DissolveSegments( geom Geometry ) : Geometry
ST_DissolveSegments( geom Geometry ) : Geometry
DissolvePoints( geom Geometry ) : Geometry
ST_DissolvePoints( geom Geometry ) : Geometry
LinesFromRings( geom Geometry ) : Geometry
ST_LinesFromRings( geom Geometry ) : Geometry
LinesCutAtNodes( geom1 Geometry , geom2 Geometry ) : Geometry
ST_LinesCutAtNodes( geom1 Geometry , geom2 Geometry ) : Geometry
RingsCutAtNodes( geom Geometry ) : Geometry
ST_RingsCutAtNodes( geom Geometry ) : Geometry
CollectionExtract( geom Geometry , type Integer ) : Geometry
ST_CollectionExtract( geom Geometry , type Integer ) : Geometry
ExtractMultiPoint( geom Geometry ) : Geometry
ExtractMultiLinestring( geom Geometry ) : Geometry
ExtractMultiPolygon( geom Geometry ) : Geometry
ST_Locate_Along_Measure( geom Geometry , m_value Double precision ) : Geometry
ST_LocateAlong( geom Geometry , m_value Double precision ) : Geometry
ST_Locate_Between_Measures( geom Geometry , m_start Double precision , m_end Double precision ) : Geometry
ST_LocateBetween( geom Geometry , m_start Double precision , m_end Double precision ) : Geometry
DelaunayTriangulation( geom Geometry [ , edges_only Boolean [ , tolerance Double precision ] ] ) : Geometry
ST_DelaunayTriangulation( geom Geometry [ , edges_only Boolean [ , tolerance Double precision ] ] ) : Geometry
VoronojDiagram( geom Geometry [ , edges_only Boolean [ , frame_extra_size Double precision [ , tolerance Double precision ] ] ] ) : Geometry
ST_VoronojDiagram( geom Geometry [ , edges_only Boolean [ , frame_extra_size Double precision [ , tolerance Double precision ] ] ] ) : Geometry
ConcaveHull( geom Geometry [ , factor Double precision [ , allow_holes Boolean [ , tolerance Double precision ] ] ] ) : Geometry
ST_ConcaveHull( geom Geometry [ , factor Double precision [ , allow_holes Boolean [ , tolerance Double precision ] ] ] ) : Geometry
MakeValid( geom Geometry ) : Geometry
ST_MakeValid( geom Geometry ) : Geometry
MakeValidDiscarded( geom Geometry ) : Geometry
ST_MakeValidDiscarded( geom Geometry ) : Geometry
Segmentize( geom Geometry, dist Double precision ) : Geometry
ST_Segmentize( geom Geometry , dist Double precision ) : Geometry
Split( geom Geometry, blade Geometry ) : Geometry
ST_Split( geom Geometry , blade Geometry ) : Geometry
SplitLeft( geom Geometry, blade Geometry ) : Geometry
ST_SplitLeft( geom Geometry , blade Geometry ) : Geometry
SplitRight( geom Geometry, blade Geometry ) : Geometry
ST_SplitRight( geom Geometry , blade Geometry ) : Geometry
Azimuth( pt1 Geometry, pt2 Geometry ) : Double precision
ST_Azimuth( pt1 Geometry , pt2 Geometry ) : Double precision
Project( start_point Geometry, distance Double precision, azimuth Double precision ) : Geometry
ST_Project( start_point Geometry, distance Double precision, azimuth Double precision ) : Geometry
SnapToGrid( geom Geometry , size Double precision ) : Geometry
SnapToGrid( geom Geometry , size_x Double precision , size_y Double precision ) : Geometry
SnapToGrid( geom Geometry , origin_x Double precision , origin_y Double precision , size_x Double precision , size_y Double precision ) : Geometry
SnapToGrid( geom Geometry , origin Geometry , size_x Double precision , size_y Double precision , size_z Double precision , size_m Double precision ) : Geometry
ST_SnapToGrid( geom Geometry , size Double precision ) : Geometry
ST_SnapToGrid( geom Geometry , size_x Double precision , size_y Double precision )
ST_SnapToGrid( geom Geometry , origin_x Double precision , origin_y Double precision , size_x Double precision , size_y Double precision )
ST_SnapToGrid( geom Geometry , origin Geometry , size_x Double precision , size_y Double precision , size_z Double precision , size_m Double precision ) : Geometry
GeoHash( geom Geometry ) : String
ST_GeoHash( geom Geometry ) : String
AsX3D( geom Geometry ) : String
AsX3D( geom Geometry , precision Integer ) : String
AsX3D( geom Geometry , precision Integer , options Integer ) : String
AsX3D( geom Geometry , precision Integer , options Integer , refid String ) : String
ST_AsX3D( geom Geometry ) : String
ST_AsX3D( geom Geometry , precision Integer ) : String
ST_AsX3D( geom Geometry , precision Integer , options Integer ) : String
ST_AsX3D( geom Geometry , precision Integer , options Integer , refid String ) : String
MaxDistance( geom1 Geometry , geom2 Geometry ) : Double precision
ST_MaxDistance( geom1 Geometry , geom2 Geometry ) : Double precision
ST_3DDistance( geom1 Geometry , geom2 Geometry ) : Double precision
ST_3DMaxDistance( geom1 Geometry , geom2 Geometry ) : Double precision
ST_Node( geom Geometry ) : Geometry
SelfIntersections( geom Geometry ) : Geometry
ST_SelfIntersections( geom Geometry ) : Geometry
Transform( geom Geometry , newSRID Integer ) : Geometry
ST_Transform( geom Geometry , newSRID Integer ) : Geometry
SridFromAuthCRS( auth_name String , auth_SRID Integer ) : Integer
ShiftCoords( geom Geometry , shiftX Double precision , shiftY Double precision ) : Geometry
ShiftCoordinates( geom Geometry , shiftX Double precision , shiftY Double precision ) : Geometry
ST_Translate( geom Geometry , shiftX Double precision , shiftY Double precision , shiftZ Double precision ) : Geometry
ST_Shift_Longitude( geom Geometry ) : Geometry
NormalizeLonLat( geom Geometry ) : Geometry
ScaleCoords( geom Geometry , scaleX Double precision [ , scaleY Double precision ] ) : Geometry
ScaleCoordinates( geom Geometry , scaleX Double precision [ , scaleY Double precision ] ) : Geometry
RotateCoords( geom Geometry , angleInDegrees Double precision ) : Geometry
RotateCoordinates( geom Geometry , angleInDegrees Double precision ) : Geometry
ReflectCoords( geom Geometry , xAxis Integer , yAxis Integer ) : Geometry
ReflectCoordinates( geom Geometry , xAxis Integer , yAxis Integer ) : Geometry
SwapCoords( geom Geometry ) : Geometry
SwapCoordinates( geom Geometry ) : Geometry
ATM_Create( void ) : AffineMatrix
ATM_Create( a Integer , b Integer , d Integer , e Integer , xoff Integer , yoff Integer ] ) : AffineMatrix
ATM_Create( a Integer , b Integer , c Integer , d Integer , e Integer , f Integer , g Integer , h Integer , i Integer , xoff Integer , yoff Integer , zoff Integer ] ) : AffineMatrix
ATM_CreateTranslate( tx Double precision , ty Double precision ] ) : AffineMatrix
ATM_CreateTranslate( tx Double precision , ty Double precision , tz Double precision ] ) : AffineMatrix
ATM_CreateScale( sx Double precision , sy Double precision ] ) : AffineMatrix
ATM_CreateScale( sx Double precision , sy Double precision , sz Double precision ] ) : AffineMatrix
ATM_CreateRotate( angleInDegrees Double precision ] ) : AffineMatrix
ATM_CreateZRoll( angleInDegrees Double precision ] ) : AffineMatrix
ATM_CreateXRoll( angleInDegrees Double precision ] ) : AffineMatrix
ATM_CreateYRoll( angleInDegrees Double precision ] ) : AffineMatrix
ATM_Multiply( matrixA AffineMatrix , matrixB AffineMatrix ) : AffineMatrix
ATM_Translate( matrix AffineMatrix , tx Double precision , ty Double precision ] ) : AffineMatrix
ATM_CreateTranslate( matrix AffineMatrix , tx Double precision , ty Double precision , tz Double precision ] ) : AffineMatrix
ATM_Scale( matrix AffineMatrix , sx Double precision , sy Double precision ] ) : AffineMatrix
ATM_Scale( matrix AffineMatrix , sx Double precision , sy Double precision , sz Double precision ] ) : AffineMatrix
ATM_Rotate( matrix AffineMatrix , angleInDegrees Double precision ] ) : AffineMatrix
ATM_ZRoll( matrix AffineMatrix , angleInDegrees Double precision ] ) : AffineMatrix
ATM_XRoll( matrix AffineMatrix , angleInDegrees Double precision ] ) : AffineMatrix
ATM_YRoll( matrix AffineMatrix , angleInDegrees Double precision ] ) : AffineMatrix
ATM_Determinant( matrix AffineMatrix ] ) : Double precision
ATM_IsInvertible( matrix AffineMatrix ] ) : Integer
ATM_Invert( matrix AffineMatrix ] ) : AffineMatrix
ATM_IsValid( matrix AffineMatrix ] ) : Integer
ATM_AsText( matrix AffineMatrix ] ) : Text
ATM_Transform( geom Geometry , matrix AffineMatrix [ , newSRID Integer ] ) : Geometry
GCP_Compute( pointA Geometry , pointB Geometry [ order Integer] ) : PolynomialCoeffs
GCP_IsValid( matrix PolynomialCoeffs ] ) : Integer
GCP_AsText( matrix PolynomialCoeffs ] ) : Text
GCP2ATM( matrix PolynomialCoeffs ] ) : AffineMatrix
GCP_Transform( geom Geometry , coeffs PolynomialCoeffs [ , newSRID Integer ] ) : Geometry
InitSpatialMetaData( void ) : Integer
InitSpatialMetaData( transaction Integer ) : Integer
InitSpatialMetaData( mode String ) : Integer
InitSpatialMetaData( transaction Integer , mode String ) : Integer
InsertEpsgSrid( srid Integer ) : Integer
AddGeometryColumn( table String , column String , srid Integer , geom_type String [ , dimension String [ , not_null Integer ] ] ) : Integer
RecoverGeometryColumn( table String , column String , srid Integer , geom_type String [ , dimension Integer ] ) : Integer
DiscardGeometryColumn( table String , column String ) : Integer
RegisterVirtualGeometry( table String ) : Integer
DropVirtualGeometry( table String ) : Integer
CreateSpatialIndex( table String , column String ) : Integer
CreateMbrCache( table String , column String ) : Integer
DisableSpatialIndex( table String , column String ) : Integer
CheckShadowedRowid( table String ) : Integer
CheckWithoutRowid( table String ) : Integer
CheckSpatialIndex( void ) : Integer
CheckSpatialIndex( table String , column String ) : Integer
RecoverSpatialIndex( [ no_check : Integer ] ) : Integer
RecoverSpatialIndex( table String , column String [ , no_check : Integer ] ) : Integer
InvalidateLayerStatistics( [ void ) : Integer
InvalidateLayerStatistics( table String [ , column String ] ) : Integer
UpdateLayerStatistics( [ void ) : Integer
UpdateLayerStatistics( table String [ , column String ] ) : Integer
GetLayerExtent( table String [ , column String [ , mode Boolean] ] ) : Geometry
CreateTopologyTables( SRID Integer , dims : String ) : Integer
CreateTopologyTables( prefix String , SRID Integer , dims : String ) : Integer
CreateRasterCoveragesTable( void ) : Integer
CreateVectorCoveragesTables( void ) : Integer
RebuildGeometryTriggers( table_name String , geometry_column_name String ) : integer
UpgradeGeometryTriggers( transaction Integer ) : integer
CreateMetaCatalogTables( transaction Integer ) : Integer
UpdateMetaCatalogStatistics( transaction Integer , table_name String , column_name String ) : Integer
UpdateMetaCatalogStatistics( transaction Integer , master_table String , table_name String , column_name String ) : Integer
CreateStylingTables() : Integer CreateStylingTables( relaxed Integer ) : Integer
CreateStylingTables( relaxed Integer , transaction Integer ) : Integer
SE_RegisterVectorCoverage( coverage_name String , f_table_name String , f_geometry_column Sting ) : Integer
SE_RegisterVectorCoverage( coverage_name String , f_table_name String , f_geometry_column Sting , title String , abstract String ) : Integer
SE_UnregisterVectorCoverage( coverage_name String ) : Integer
SE_SetVectorCoverageInfos( coverage_name String , title String , abstract String ) : Integer
SE_RegisterVectorCoverageSrid( coverage_name String , srid Integer ) : Integer
SE_UnregisterVectorCoverageSrid( coverage_name String , srid Integer ) : Integer
SE_UpdateVectorCoverageExtent() : Integer SE_UpdateVectorCoverageExtent( transaction Integer ) : Integer
SE_UpdateVectorCoverageExtent( coverage_name String ) : Integer
SE_UpdateVectorCoverageExtent( coverage_name String , transaction Integer ) : Integer
SE_RegisterVectorCoverageeKeyword( coverage_name String , keyword String ) : Integer
SE_UnregisterVectorCoverageKeyword( coverage_name String , keyword String ) : Integer
SE_RegisterExternalGraphic( xlink_href String , resource BLOB ) : Integer
SE_RegisterExternalGraphic( xlink_href String , resource BLOB , title String , abstract String , file_name String ) : Integer
SE_UnregisterExternalGraphic( xlink_href String ) : Integer
SE_RegisterVectorStyle( style BLOB ) : Integer
SE_UnregisterVectorStyle( style_id Integer [ , remove_all Integer ] ) : Integer
SE_UnregisterVectorStyle( style_name Text [ , remove_all Integer ] ) : Integer
SE_ReloadVectorStyle( style_id Integer , style BLOB ) : Integer
SE_ReloadVectorStyle( style_name Text , style BLOB ) : Integer
SE_RegisterVectorStyledLayer( coverage_name String , style_id Integer ) : Integer
SE_RegisterVectorStyledLayer( coverage_name String , style_name Text ) : Integer
SE_UnregisterVectorStyledLayer( coverage_name String , style_id Integer ) : Integer
SE_UnregisterVectorStyledLayer( coverage_name String , style_name Text ) : Integer
SE_RegisterRasterStyle( style BLOB ) : Integer
SE_UnregisterRasterStyle( style_id Integer [ , remove_all Integer ] ) : Integer
SE_UnregisterRasterStyle( style_name Text [ , remove_all Integer ] ) : Integer
SE_ReloadRasterStyle( style_id Integer , style BLOB ) : Integer
SE_ReloadRasterStyle( style_name Text , style BLOB ) : Integer
SE_RegisterRasterStyledLayer( coverage_name String , style_id Integer ) : Integer
SE_RegisterRasterStyledLayer( coverage_name String , style_name Text ) : Integer
SE_UnregisterRasterStyledLayer( coverage_name String , style_id Integer ) : Integer
SE_UnregisterRasterStyledLayer( coverage_name String , style_name Text ) : Integer
SE_RegisterRasterCoverageSrid( coverage_name String , srid Integer ) : Integer
SE_UnregisterRasterCoverageSrid( coverage_name String , srid Integer ) : Integer
SE_UpdateRasterCoverageExtent() : Integer SE_UpdateRasterCoverageExtent( transaction Integer ) : Integer
SE_UpdateRasterCoverageExtent( coverage_name String ) : Integer
SE_UpdateRasterCoverageExtent( coverage_name String , transaction Integer ) : Integer
SE_RegisterRasterCoverageKeyword( coverage_name String , keyword String ) : Integer
SE_UnregisterRasterCoverageKeyword( coverage_name String , keyword String ) : Integer
SE_SetStyledGroupInfos( group_name String , title String , abstract String ) : Integer
SE_UnregisterStyledGroup( group_name String ) : Integer
SE_RegisterStyledGroupVector( group_name String , coverage_name String ) : Integer
SE_RegisterStyledGroupRaster( group_name String , coverage_name String ) : Integer
SE_SetStyledGroupLayerPaintOrder( item_id Integer , paint_order Integer ) : Integer
SE_SetStyledGroupVectorPaintOrder( group_name Text , coverage_name String , paint_order Integer ) : Integer
SE_SetStyledGroupRasterPaintOrder( group_name Text , coverage_name String , paint_order Integer ) : Integer
SE_UnregisterStyledGroupLayer( item_id Integer ) : Integer
SE_UnregisterStyledGroupVector( group_name Text , coverage_name String ) : Integer
SE_UnregisterStyledGroupRaster( group_name Text , coverage_name String ) : Integer
SE_RegisterGroupStyle( style BLOB ) : Integer
SE_UnregisterGroupStyle( style_id Integer [ , remove_all Integer ] ) : Integer
SE_UnregisterGroupStyle( style_name Text [ , remove_all Integer ] ) : Integer
SE_ReloadGroupStyle( style_id Integer , style BLOB ) : Integer
SE_ReloadGroupStyle( style_name Text , style BLOB ) : Integer
SE_RegisterStyledGroupStyle( group_name String , style_id Integer ) : Integer
SE_RegisterStyledGroupStyle( group_name String , style_name Text ) : Integer
SE_UnregisterStyledGroupStyle( group_name String , style_id Integer ) : Integer
SE_UnregisterStyledGroupStyle( group_name String , style_name Text ) : Integer
CreateIsoMetadataTables() : Integer CreateIsoMetadataTables( relaxed Integer ) : Integer
RegisterIsoMetadata( scope String , metadata BLOB ) : Integer
RegisterIsoMetadata( scope String , metadata BLOB , id Integer ) : Integer
RegisterIsoMetadata( scope String , metadata BLOB , fileIdentifier String ) : Integer
GetIsoMetadataId( fileIdentifier String ) : Integer
CheckSpatialMetaData( void ) : Integer
AutoFDOStart( void ) : Integer
AutoFDOStop( void ) : Integer
InitFDOSpatialMetaData( void ) : Integer
AddFDOGeometryColumn( table String , column String , srid Integer , geom_type Integer , dimension Integer, geometry_format String ) : Integer
RecoverFDOGeometryColumn( table String , column String , srid Integer , geom_type String , dimension Integer, geometry_format String ) : Integer
DiscardFDOGeometryColumn( table String , column String ) : Integer
CheckGeoPackageMetaData( void ) : Integer
AutoGPKGStart( void ) : Integer
AutoGPKGStop( void ) : Integer
gpkgCreateBaseTables( void ) : void
gpkgInsertEpsgSRID( srid Integer ) : void
gpkgCreateTilesTable( tile_table_name String , srid Integer , min_x Double precision , min_y Double precision , max_x Double precision , max_y Double precision ) : void
gpkgCreateTilesZoomLevel( tile_table_name String, zoom_level Integer , extent_width Double precision , extent_height Double precision ) : void
gpkgAddTileTriggers( tile_table_name String ) : void
gpkgGetNormalZoom( tile_table_name String , inverted_zoom_level Integer ) : Integer
gpkgGetNormalRow( tile_table_name String , normal_zoom_level Integer , inverted_row_number Integer ) : Integer
gpkgGetImageType( image Blob ) : String
gpkgAddGeomtryColumn( table_name Sting, geometry_column_name String , geometry_type String , with_z Integer , with_m Integer , srs_id Integer ) : void
gpkgAddGeometryTriggers( table_name String , geometry_column_name String ) : void
gpkgAddSpatialIndex( table_name String , geometry_column_name String ) : void
IsValidGPB( geom Blob ) : Integer
AsGPB( geom BLOB encoded geometry ) : GPKG Blob Geometry
GeomFromGPB( geom GPKG Blob Geometry ) : BLOB encoded geometry
CastAutomagic( geom Blob ) : BLOB encoded geometry
GPKG_IsAssignable( expected_type_name String , actual_type_name String ) : Integer
FilterMbrWithin( x1 Double precision , y1 Double precision , x2 Double precision , y2 Double precision )
FilterMbrContains( x1 Double precision , y1 Double precision , x2 Double precision , y2 Double precision )
FilterMbrIntersects( x1 Double precision , y1 Double precision , x2 Double precision , y2 Double precision )
BuildMbrFilter( x1 Double precision , y1 Double precision , x2 Double precision , y2 Double precision )
RTreeIntersects( x1 Double precision , y1 Double precision , x2 Double precision , y2 Double precision )
RTreeWithin( x1 Double precision , y1 Double precision , x2 Double precision , y2 Double precision )
RTreeContains( x1 Double precision , y1 Double precision , x2 Double precision , y2 Double precision )
RTreeDistWithin( x Double precision , y Double precision , radius Double precision )
XB_Create( xmlPayload BLOB ) : XmlBLOB
XB_Create( xmlPayload BLOB , compressed Boolean ) : XmlBLOB
XB_Create( xmlPayload BLOB , compressed Boolean , schemaURI Text ) : XmlBLOB
XB_Create( xmlPayload BLOB , compressed Boolean , internalSchemaURI Boolean ) : XmlBLOB
XB_GetPayload( xmlObject XmlBLOB [ , indent Integer ] ) : BLOB
XB_GetDocument( xmlObject XmlBLOB [ , indent Integer ] ) : String
XB_SchemaValidate( xmlObject XmlBLOB , schemaURI Text [ , compressed Boolean ] ) : XmlBLOB
XB_SchemaValidate( xmlObject XmlBLOB , internalSchemaURI Boolean [ , compressed Boolean ] ) : XmlBLOB
XB_Compress( xmlObject XmlBLOB ) : XmlBLOB
XB_Uncompress( xmlObject XmlBLOB ) : XmlBLOB
XB_IsValid( xmlObject XmlBLOB ) : Integer
XB_IsCompressed( xmlObject XmlBLOB ) : Integer
XB_IsSchemaValidated( xmlObject XmlBLOB ) : Integer
XB_IsIsoMetadata( xmlObject XmlBLOB ) : Integer
XB_IsSldSeVectorStyle( xmlObject XmlBLOB ) : Integer
XB_IsSldSeRasterStyle( xmlObject XmlBLOB ) : Integer
XB_IsSvg( xmlObject XmlBLOB ) : Integer
XB_GetDocumentSize( xmlObject XmlBLOB ) : Integer
XB_GetEncoding( xmlObject XmlBLOB ) : String
XB_GetSchemaURI( xmlObject XmlBLOB ) : String
XB_GetInternalSchemaURI( xmlPayload BLOB ) : String
XB_GetFileId( xmlObject XmlBLOB ) : String
XB_SetFileId( xmlObject XmlBLOB , fileId String ) : XmlBLOB
XB_AddFileId( xmlObject XmlBLOB , fileId String , IdNameSpacePrefix String , IdNameSpaceURI String , CsNameSpacePrefix String , CsNameSpaceURI String ) : XmlBLOB
XB_GetParentId( xmlObject XmlBLOB ) : String
XB_SetParentId( xmlObject XmlBLOB , parentId String ) : XmlBLOB
XB_AddParentId( xmlObject XmlBLOB , parentId String , IdNameSpacePrefix String , IdNameSpaceURI String , CsNameSpacePrefix String , CsNameSpaceURI String ) : XmlBLOB
XB_GetTitle( xmlObject XmlBLOB ) : String
XB_GetAbstract( xmlObject XmlBLOB ) : String
XB_GetGeometry( xmlObject XmlBLOB ) : Geometry
XB_GetLastParseError( void ) : String
XB_GetLastValidateError( void ) : String
XB_IsValidXPathExpression( expr Text ) : Integer
XB_GetLastXPathError( void ) : String
XB_CacheFlush( void ) : Boolean
XB_LoadXML( filepath-or-URL String ) : BLOB
XB_StoreXML( XmlObject XmlBLOB , filepath String ) : Integer
XB_StoreXML( XmlObject XmlBLOB , filepath String , indent Integer ) : Integer
SridIsGeographic( SRID Integer ) : Integer
SridIsProjected( SRID Integer ) : Integer
SridHasFlippedAxes( SRID Integer ) : Integer
SridGetSpheroid( SRID Integer ) : Text
SridGetEllipsoid( SRID Integer ) : Text
SridGetPrimeMeridian( SRID Integer ) : Text
SridGetDatum( SRID Integer ) : Text
SridGetUnit( SRID Integer ) : Text
SridGetProjection( SRID Integer ) : Text
SridGetAxis_1_Name( SRID Integer ) : Text
SridGetAxis_1_Orientation( SRID Integer ) : Text
SridGetAxis_2_Name( SRID Integer ) : Text
SridGetAxis_2_Orientation( SRID Integer ) : Text
CloneTable( db-prefix Text , input_table Text , output_table Text , transaction Integer ) : Integer
CloneTable( db-prefix Text , input_table Text , output_table Text , transaction Integer , option_1 Text [ , ... , option_10 Text ] ) : Integer
CheckDuplicateRows( table Text ) : Integer
RemoveDuplicateRows( table Text ) : Integer
RemoveDuplicateRows( table Text , transaction Boolean ) : Integer
ElementaryGeometries( in_table Text , geom_column Text , out_table Text , out_pk Text , out_multi_id Text ) : Integer
ElementaryGeometries( in_table Text , geom_column Text , out_table Text , out_pk Text , out_multi_id Text , transaction Boolean ) : Integer
DropGeoTable( table Text ) : Integer
DropGeoTable( table Text , transaction Boolean ) : Integer
DropGeoTable( db-prefix Text , table Text ) : Integer
DropGeoTable( db-prefix Text , table Text , transaction Boolean ) : Integer
ImportSHP( filename Text , table Text , charset Text ) : Integer
ImportSHP( filename Text , table Text , charset Text [ , srid Integer [ , geom_column Text [ , pk_column Text [ , geometry_type Text [ , coerce2D Integer [ , compressed Integer [ , spatial_index Integer [ , text_dates Integer ] ] ] ] ] ] ] ] )
ExportSHP( table Text , geom_column Text , filename Text , charset Text ) : Integer
ExportSHP( table Text , geom_column Text , filename Text , charset Text , geom_type Text) : Integer
ImportDBF( filename Text , table Text , charset Text ) : Integer
ImportDBF( filename Text , table Text , charset Text [ , pk_column Text [ , text_dates Integer ] ] ) : Integer
ExportDBF( table Text , filename Text , charset Text ) : Integer
ExportKML( table Text , geo_column Text , filename Text ) : Integer
ExportKML( table Text , geo_column Text , filename Text [ , precision Integer [ , name_column Text [ , description Text ] ] ] ) : Integer
ExportGeoJSON( table Text , geo_column Text , filename Text ) : Integer
ExportGeoJSON( table Text , geo_column Text , filename Text [ , format Text [ , precision Integer ] ] ) : Integer
ImportXLS( filename Text , table Text ) : Integer
ImportXLS( filename Text , table Text [ , worksheet_index Integer [ , first_line_titles Integer ] ] ) : Integer
ImportWFS( filename_or_url Text , layer_name Text , table Text ) : Integer
ImportXLS( filename_or_url Text , layer_name Text , table Text [ , pk_column Text [ , swap_axes Integer [ , page_size Integer [ , spatial_index Integer ] ] ] ] ) : Integer
ImportDXF( filename String ) : Integer
ImportDXF( filename String [ , srid Integer, append Integer, dimensions Text, mode Text , special_rings Text , table_prefix Text , layer_name Text ] ) : Integer
ImportDXFfromDir( dir_path String ) : Integer
ImportDXFfromDir( dir_path String [ , srid Integer, append Integer, dimensions Text, mode Text , special_rings Text , table_prefix Text , layer_name Text ] ) : Integer
ExportDXF( out_dir String , filename String , sql_query String , layer_col_name String , geom_col_name String , label_col_name String , text_height_col_name String , text_rotation_col_name String , geom_filter Geometry [ , precision Integer ] ) : Integer
")
        (goto-char (point-min))
        (while (search-forward-regexp
                (rx bol (group (one-or-more (char alnum "._")))
                    (one-or-more nonl)
                    eol) nil t)
          (let ((key (downcase (match-string 1))))
            (puthash key
                     (cons (match-string 0)
                           (gethash key spatialite-syntax))
                     spatialite-syntax))))
      spatialite-syntax)))

(defvar sql-mode-spatialite-keywords
  '("abort" "action" "add" "after" "all" "alter" "analyze" "and" "as"
"asc" "attach" "autoincrement" "before" "begin" "between" "by"
"cascade" "case" "cast" "check" "collate" "column" "commit" "conflict"
"constraint" "create" "cross" "database" "default" "deferrable"
"deferred" "delete" "desc" "detach" "distinct" "drop" "each" "else"
"end" "escape" "except" "exclusive" "exists" "explain" "fail" "for"
"foreign" "from" "full" "glob" "group" "having" "if" "ignore"
"immediate" "in" "index" "indexed" "initially" "inner" "insert"
"instead" "intersect" "into" "is" "isnull" "join" "key" "left" "like"
"limit" "match" "natural" "no" "not" "notnull" "null" "of" "offset"
"on" "or" "order" "outer" "plan" "pragma" "primary" "query" "raise"
"references" "regexp" "reindex" "release" "rename" "replace"
"restrict" "right" "rollback" "row" "savepoint" "select" "set" "table"
"temp" "temporary" "then" "to" "transaction" "trigger" "union"
"unique" "update" "using" "vacuum" "values" "view" "virtual" "when"
"where"))

(defvar sql-mode-spatialite-types
  '("int" "integer" "tinyint" "smallint" "mediumint" "bigint" "unsigned"
"big" "int2" "int8" "character" "varchar" "varying" "nchar" "native"
"nvarchar" "text" "clob" "blob" "real" "double" "precision" "float"
"numeric" "number" "decimal" "boolean" "date" "datetime"))

(defvar sql-mode-spatialite-font-lock-keywords
  (eval-when-compile
    (require 'subr-x)
    (list
     ;; SQLite 
     '("^[.].*$" . font-lock-doc-face)

     ;; SQLite Keyword
     (apply 'sql-font-lock-keywords-builder 'font-lock-keyword-face nil sql-mode-spatialite-keywords)

     ;; SQLite Data types
     (apply 'sql-font-lock-keywords-builder 'font-lock-type-face nil sql-mode-spatialite-types)

     ;; SQLite Functions
     (apply #'sql-font-lock-keywords-builder 'font-lock-builtin-face nil
            ;; spatialite extra functions
            (hash-table-keys spatialite-syntax))
     ))

  "Spatialite SQL keywords used by font-lock.")

(sql-add-product
 'spatialite "Spatialite"
 :free-software t
 :font-lock 'sql-mode-spatialite-font-lock-keywords
 :sqli-program 'sql-spatialite-program
 :sqli-options 'sql-spatialite-options
 :sqli-login 'sql-sqlite-login-params
 :sqli-comint-func 'sql-comint-spatialite
 :list-all ".tables"
 :list-table ".schema %s"
 :completion-object 'sql-sqlite-completion-object
 :prompt-regexp "^spatialite> "
 :prompt-length 12
 :prompt-cont-regexp "^   \\.\\.\\.> "
 :terminator ";"
 :syntax-alist '((?. . "_")))

(defun spatialite-highlight-argument (arg str)
  (condition-case ()
      (let ((start (if (= ?. (aref str 0))
                       " " "("))
            (split (if (= ?. (aref str 0))
                       " " ","))
            (str (substring-no-properties str)))
        (save-match-data
          (string-match start str)
          (let ((c0 (match-end 0)))
            (while (and (> arg 0)
                        (string-match split str c0))
              (setq c0 (match-end 0)
                    arg (- arg 1)))
            (if (= 0 arg)
                (progn
                  (string-match ",\\|)\\|\\'" str c0)
                  (put-text-property c0 (- (match-end 0) 1) 'face 'bold str)
                  str)
              nil))))
    (error str)))

(defun spatialite-eldoc-function ()
  "Compute a docstring for spatialite function at point, if there is one."
  (if (eq sql-product 'spatialite)

      (let ((begin (point)))
        (if-let ((word (thing-at-point 'symbol))
                 (docs (gethash (downcase word) spatialite-syntax)))
            (mapconcat 'identity docs "\n")
          ;; otherwise, check for function call

          ;;TODO: this part does not quite work for .loadshp etc, because
          ;;      backward-up-list fails. bah.
          (save-match-data
            (save-excursion
              (when (and (condition-case ()
                             (or (backward-up-list) t)
                           (error nil))
                         (eq ?\( (char-after)))
                (skip-syntax-backward "-")

                (if-let ((word (thing-at-point 'symbol))
                         (docs (gethash (downcase word) spatialite-syntax)))
                    (let ((split (if (= ?. (aref word 0)) " " ","))
                          (commas 0))
                      (while (search-forward split begin t)
                        (setq commas (1+ commas)))
                      (mapconcat 'identity
                                 (delq nil
                                       (mapcar
                                        (lambda (x) (spatialite-highlight-argument commas x))
                                        docs))
                                 "\n"))
                  ))))))))

(defun spatialite-completion-at-point ()
  (save-excursion
    (if-let ((is-spatialite (eq sql-product 'spatialite))
             (bounds (bounds-of-thing-at-point 'symbol)))
        (list (car bounds)
              (cdr bounds)
              (hash-table-keys spatialite-syntax)
              :exclusive 'no
              :company-docsig (lambda (cand) (gethash cand spatialite-syntax))))))

(defun sql-enable-eldoc ()
  (message "enabling eldoc support")
  (add-function :before-until (local 'eldoc-documentation-function) #'spatialite-eldoc-function)
  (add-to-list 'completion-at-point-functions #'spatialite-completion-at-point)
  (setq-local completion-ignore-case t))

(add-hook 'sql-mode-hook #'sql-enable-eldoc)
(add-hook 'sql-mode-hook #'eldoc-mode)
(add-hook 'sql-interactive-mode-hook #'sql-enable-eldoc)
(add-hook 'sql-interactive-mode-hook #'eldoc-mode)

(defun sql-spatialite (&optional buffer)
  (interactive "P")
  (sql-product-interactive 'spatialite buffer))

(provide 'sql-spatialite)
