/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

//import org.nemomobile.qtmpris 1.0

import org.nemomobile.mpris 1.0


Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Show Page 2")
                onClicked: pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("MPRIS Control")
            }
            Label {
                x: Theme.horizontalPageMargin
                text: qsTr("Hello Sailors")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
            }
            Label {
                id: artistLabel

                x: Theme.horizontalPageMargin
                text: if (mprisManager.currentService) {
                    var artistTag = Mpris.metadataToString(Mpris.Artist)

                    return (artistTag in mprisManager.metadata) ? mprisManager.metadata[artistTag].toString() : ""
                }
//                width: parent.width
                elide: Text.ElideRight
//                horizontalAlignment: Text.AlignHCenter
            }
            Label {
                id: songLabel

                x: Theme.horizontalPageMargin
                text: if (mprisManager.currentService) {
                    var titleTag = Mpris.metadataToString(Mpris.Title)

                    return (titleTag in mprisManager.metadata) ? mprisManager.metadata[titleTag].toString() : ""
                }
//                width: parent.width
                elide: Text.ElideRight
//                horizontalAlignment: Text.AlignHCenter
            }

            Row {
            IconButton {

//                width: controls.parent.width * 0.25
//                height: width

                onClicked: if (mprisManager.canGoPrevious) mprisManager.previous()
                icon.source: "image://theme/icon-m-previous"
            }
            IconButton {
                property bool isPlaying: mprisManager.currentService && mprisManager.playbackStatus == Mpris.Playing

                onClicked: {
                    if ((isPlaying && mprisManager.canPause) || (!isPlaying && mprisManager.canPlay))
                    mprisManager.playPause();
                    else console.log("not playPausing", "isPlaying", isPlaying,
                                     "mprisManager.canPause", mprisManager.canPause, "mprisManager.canPlay", mprisManager.canPlay)
                }
                icon.source: isPlaying ?"image://theme/icon-l-pause" : "image://theme/icon-l-play"
            }
            IconButton {

                onClicked: if (mprisManager.canGoNext) mprisManager.next()
                icon.source: "image://theme/icon-m-next"
            }

}



        }
        MprisManager {
            id: mprisManager
        }

//        Loader {
//            id: controlsLoader

//            active: mprisManager.availableServices.length > 0

//            Component.onCompleted: setSource("MprisControls.qml", { "mprisManager": mprisManager, "parent": mainItem })

//        }
    }
}

