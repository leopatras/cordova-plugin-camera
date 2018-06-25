IMPORT util

CONSTANT quality=50
CONSTANT DestinationTypeDataUrl = 0
CONSTANT DestinationTypeFileUri = 1
CONSTANT DestinationTypeNativeUri = 2

CONSTANT PictureSourceTypePhotoLibrary= 0 -- Choose image from the device's photo library (same as SAVEDPHOTOALBUM for Android) 
CONSTANT PictureSourceTypeCamera= 1 -- Take picture from camera
CONSTANT PictureSourceTypeSavedPhotoAlbum= 2 -- Choose image only from the device's Camera Roll album (same as PHOTOLIBRARY for Android)

--CONSTANT targetWidth=600
--CONSTANT targetHeight=600
CONSTANT targetWidth=""
CONSTANT targetHeight=""

CONSTANT  EncodingTypeJPEG=0 --Return JPEG encoded image
CONSTANT  EncodingTypePNG=1 --Return PNG encoded image

CONSTANT  MediaTypePicture=0 --Allow selection of still pictures only. DEFAULT. Will return format specified via DestinationType
CONSTANT  MediaTypeVideo=1 --Allow selection of video only, ONLY RETURNS URL */
CONSTANT  MediaTypeAll=2 --Allow selection from all media types

CONSTANT allowsEditing=FALSE
CONSTANT correctOrientation=TRUE
CONSTANT saveToPhotoAlbum=TRUE

CONSTANT PopoverArrowDirectionUp=1
CONSTANT PopoverArrowDirectionDown=2
CONSTANT PopoverArrowDirectionLeft=4
CONSTANT PopoverArrowDirectionRight=8
CONSTANT PopoverArrowDirectionAny=15

DEFINE popoverOptions RECORD 
  x INT,
  y INT,
  width INT,
  height INT,
  arrowDir INT
END RECORD

CONSTANT  CameraDirectionBack=0 -- Use the back-facing camera
CONSTANT  CameraDirectionFront=1 -- Use the front-facing camera


MAIN
    DEFINE result STRING
    DEFINE ch base.Channel
    --OPEN FORM f FROM "main"
    --DISPLAY FORM f

    CALL ui.Interface.frontCall("cordova","settings",["set","CameraUsesGeolocation","true"],[])
    LET popoverOptions.x=0;
    LET popoverOptions.y=0;
    LET popoverOptions.width=400;
    LET popoverOptions.height=400;
    LET popoverOptions.arrowDir=PopoverArrowDirectionDown

    MENU "Accelerometer"
      COMMAND "getPicture"
        CALL ui.Interface.frontCall("cordova","call",
          ["Camera","takePicture",
           quality,DestinationTypeFileUri,PictureSourceTypePhotoLibrary,
            targetWidth,targetHeight,EncodingTypeJPEG,MediaTypeAll,
            allowsEditing,correctOrientation,saveToPhotoAlbum,
            popoverOptions,CameraDirectionBack],[result])
        LET ch=base.Channel.create()
        CALL ch.openFile("/tmp/result.txt","w")
        CALL ch.writeLine(result)
        CALL ch.close()
        ERROR "result:",result
    END MENU
END MAIN

