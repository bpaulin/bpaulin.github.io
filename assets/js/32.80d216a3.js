(window.webpackJsonp=window.webpackJsonp||[]).push([[32],{328:function(t,e,s){"use strict";s.r(e);var n=s(5),a=Object(n.a)({},(function(){var t=this,e=t._self._c;return e("ContentSlotsDistributor",{attrs:{"slot-key":t.$parent.slotKey}},[e("h2",{attrs:{id:"le-probleme"}},[e("a",{staticClass:"header-anchor",attrs:{href:"#le-probleme"}},[t._v("#")]),t._v(" Le problème")]),t._v(" "),e("p",[t._v("J’ai changé ma souris pour une mad catz RAT5. Elle réagit bizarrement avec mon poste (focus de la souris différent du focus ‘officiel’, impossibilité de passer un lecteur falsh en plein écran, etc).\nCes bugs surviennent quel que soit le bureau utilisé (cinnamon, xfce, gnome3 ou openbox).")]),t._v(" "),e("h2",{attrs:{id:"la-solution"}},[e("a",{staticClass:"header-anchor",attrs:{href:"#la-solution"}},[t._v("#")]),t._v(" La solution")]),t._v(" "),e("p",[t._v("Cette souris demande une déclaration spéciale au serveur X. J’ai commencé par modifier directement xorg.conf, mais je devais refaire l’opération après chaque mise à jour.\nActuellement, ce qui marche chez moi est de créer le fichier "),e("strong",[t._v("/etc/X11/xorg.conf.d/rat5.conf")]),t._v(" contenant:")]),t._v(" "),e("div",{staticClass:"language-bash extra-class"},[e("pre",{pre:!0,attrs:{class:"language-bash"}},[e("code",[t._v("Section "),e("span",{pre:!0,attrs:{class:"token string"}},[t._v('"InputClass"')]),t._v("\n    Identifier "),e("span",{pre:!0,attrs:{class:"token string"}},[t._v('"Mad Catz R.A.T. 5"')]),t._v("\n    MatchProduct "),e("span",{pre:!0,attrs:{class:"token string"}},[t._v('"Mad Catz Mad Catz R.A.T.5 Mouse"')]),t._v("\n    MatchDevicePath "),e("span",{pre:!0,attrs:{class:"token string"}},[t._v('"/dev/input/event*"')]),t._v("\n    Option "),e("span",{pre:!0,attrs:{class:"token string"}},[t._v('"Buttons"')]),t._v(" "),e("span",{pre:!0,attrs:{class:"token string"}},[t._v('"21"')]),t._v("\n    Option "),e("span",{pre:!0,attrs:{class:"token string"}},[t._v('"ButtonMapping"')]),t._v(" "),e("span",{pre:!0,attrs:{class:"token string"}},[t._v('"1 2 3 4 5 0 0 11 10 7 6 8 0 0 0 0"')]),t._v("\n    Option "),e("span",{pre:!0,attrs:{class:"token string"}},[t._v('"ZAxisMapping"')]),t._v(" "),e("span",{pre:!0,attrs:{class:"token string"}},[t._v('"4 5 11 10"')]),t._v("\n    Option "),e("span",{pre:!0,attrs:{class:"token string"}},[t._v('"AutoReleaseButtons"')]),t._v(" "),e("span",{pre:!0,attrs:{class:"token string"}},[t._v('"13 14 15"')]),t._v("\nEndSection\n")])])]),e("p",[t._v("Après redemarrage, tout fonctionne...")])])}),[],!1,null,null,null);e.default=a.exports}}]);