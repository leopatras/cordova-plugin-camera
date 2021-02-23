IMPORT util
IMPORT os

CONSTANT quality=100
CONSTANT DestinationTypeDataUrl = 0
CONSTANT DestinationTypeFileUri = 1
CONSTANT DestinationTypeNativeUri = 2

CONSTANT PictureSourceTypePhotoLibrary= 0 -- Choose image from the device's photo library (same as SAVEDPHOTOALBUM for Android) 
CONSTANT PictureSourceTypeCamera= 1 -- Take picture from camera
CONSTANT PictureSourceTypeSavedPhotoAlbum= 2 -- Choose image only from the device's Camera Roll album (same as PHOTOLIBRARY for Android)

CONSTANT  EncodingTypeJPEG=0 --Return JPEG encoded image
CONSTANT  EncodingTypePNG=1 --Return PNG encoded image

CONSTANT  MediaTypePicture=0 --Allow selection of still pictures only. DEFAULT. Will return format specified via DestinationType
CONSTANT  MediaTypeVideo=1 --Allow selection of video only, ONLY RETURNS URL */
CONSTANT  MediaTypeAll=2 --Allow selection from all media types

CONSTANT allowsEditing=FALSE
CONSTANT correctOrientation=TRUE
CONSTANT saveToPhotoAlbum=FALSE

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
    DEFINE result,cb STRING
    DEFINE targetWidth , targetHeight INT
    LET targetHeight=NULL
    LET targetWidth=NULL
    --IF ui.Interface.getFrontEndName()=="GMI" THEN
    --  CALL ui.Interface.frontCall("cordova","settings",["set","CameraUsesGeolocation","true"],[])
    --END IF
    LET popoverOptions.x=0;
    LET popoverOptions.y=0;
    LET popoverOptions.width=400;
    LET popoverOptions.height=400;
    LET popoverOptions.arrowDir=PopoverArrowDirectionDown

    MENU "Camera"
      BEFORE MENU
        CALL DIALOG.setActionHidden("cordovacallback",1)
      COMMAND "Choose Picture"
        TRY
          CALL ui.Interface.frontCall("cordova","call",
          ["Camera","takePicture",
           quality,DestinationTypeFileUri,PictureSourceTypePhotoLibrary,
            targetWidth,targetHeight,EncodingTypeJPEG,MediaTypeAll,
            allowsEditing,correctOrientation,saveToPhotoAlbum,
            popoverOptions,CameraDirectionBack],[result])
          CALL displayPhoto(result)
        CATCH 
          ERROR err_get(status)
        END TRY
      COMMAND "Take Picture"
        TRY
          CALL ui.Interface.frontCall("cordova","call",
          ["Camera","takePicture",
           quality,DestinationTypeFileUri,PictureSourceTypeCamera,
            targetWidth,targetHeight,EncodingTypeJPEG,MediaTypeAll,
            allowsEditing,correctOrientation,saveToPhotoAlbum,
            popoverOptions,CameraDirectionBack],[cb])
          IF cb.getIndexOf("file://",1)==1 THEN
            LET cb=cb.subString(7,cb.getLength())
          END IF
          ERROR sfmt("ret:%1,fileExists:%2,fileSize:%3",cb,os.Path.exists(cb),os.Path.size(cb))
          DISPLAY "callback:",cb
          
          CALL displayPhoto(cb)
        CATCH 
          ERROR err_get(status)
        END TRY
      ON ACTION cordovacallback ATTRIBUTE(DEFAULTVIEW=no)
        DISPLAY "cordovacallback"
        CALL ui.Interface.frontCall("cordova","getAllCallbackData",[],[result])
        DISPLAY "result:",result
    END MENU
END MAIN

FUNCTION displayPhoto(result STRING)
  CALL ui.Interface.frontCall("standard","launchurl",[result],[])
END FUNCTION

FUNCTION xdisplayPhoto(result STRING)
  DEFINE ch base.Channel
  LET ch=base.Channel.create()
  TRY
      CALL ch.openFile("/tmp/result.txt","w")
      CALL ch.writeLine(result)
      CALL ch.close()
  END TRY
  OPEN WINDOW viewer WITH FORM "main"
  DISPLAY result TO photo
  ERROR "result:",result
  MENU
    ON ACTION close
      EXIT MENU
  END MENU
  CLOSE WINDOW viewer
END FUNCTION

