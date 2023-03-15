"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[126],{3905:(e,t,r)=>{r.d(t,{Zo:()=>l,kt:()=>m});var n=r(7294);function o(e,t,r){return t in e?Object.defineProperty(e,t,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[t]=r,e}function i(e,t){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),r.push.apply(r,n)}return r}function a(e){for(var t=1;t<arguments.length;t++){var r=null!=arguments[t]?arguments[t]:{};t%2?i(Object(r),!0).forEach((function(t){o(e,t,r[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):i(Object(r)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(r,t))}))}return e}function s(e,t){if(null==e)return{};var r,n,o=function(e,t){if(null==e)return{};var r,n,o={},i=Object.keys(e);for(n=0;n<i.length;n++)r=i[n],t.indexOf(r)>=0||(o[r]=e[r]);return o}(e,t);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(n=0;n<i.length;n++)r=i[n],t.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(e,r)&&(o[r]=e[r])}return o}var p=n.createContext({}),c=function(e){var t=n.useContext(p),r=t;return e&&(r="function"==typeof e?e(t):a(a({},t),e)),r},l=function(e){var t=c(e.components);return n.createElement(p.Provider,{value:t},e.children)},u={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},d=n.forwardRef((function(e,t){var r=e.components,o=e.mdxType,i=e.originalType,p=e.parentName,l=s(e,["components","mdxType","originalType","parentName"]),d=c(r),m=o,f=d["".concat(p,".").concat(m)]||d[m]||u[m]||i;return r?n.createElement(f,a(a({ref:t},l),{},{components:r})):n.createElement(f,a({ref:t},l))}));function m(e,t){var r=arguments,o=t&&t.mdxType;if("string"==typeof e||o){var i=r.length,a=new Array(i);a[0]=d;var s={};for(var p in t)hasOwnProperty.call(t,p)&&(s[p]=t[p]);s.originalType=e,s.mdxType="string"==typeof e?e:o,a[1]=s;for(var c=2;c<i;c++)a[c]=r[c];return n.createElement.apply(null,a)}return n.createElement.apply(null,r)}d.displayName="MDXCreateElement"},918:(e,t,r)=>{r.r(t),r.d(t,{assets:()=>p,contentTitle:()=>a,default:()=>u,frontMatter:()=>i,metadata:()=>s,toc:()=>c});var n=r(3117),o=(r(7294),r(3905));const i={sidebar_position:3},a="Views",s={unversionedId:"app/views",id:"app/views",title:"Views",description:"The app is responsible for many things, but one important task that it accomplishes is registering the views for your application.",source:"@site/docs/app/views.md",sourceDirName:"app",slug:"/app/views",permalink:"/steward/docs/app/views",draft:!1,editUrl:"https://github.com/pyrestudios/steward/tree/main/docs/app/views.md",tags:[],version:"current",sidebarPosition:3,frontMatter:{sidebar_position:3},sidebar:"tutorialSidebar",previous:{title:"Configuration",permalink:"/steward/docs/app/configuration"},next:{title:"Forms",permalink:"/steward/docs/forms/"}},p={},c=[],l={toc:c};function u(e){let{components:t,...r}=e;return(0,o.kt)("wrapper",(0,n.Z)({},l,r,{components:t,mdxType:"MDXLayout"}),(0,o.kt)("h1",{id:"views"},"Views"),(0,o.kt)("p",null,"The app is responsible for many things, but one important task that it accomplishes is registering the views for your application. "),(0,o.kt)("p",null,"Views live in the ",(0,o.kt)("inlineCode",{parentName:"p"},"/views")," folder under your Steward app and are mustache files. Most interactions with Views will come from the ",(0,o.kt)("inlineCode",{parentName:"p"},"view")," method on the controller class, but you're free to work with them on your own as well. That being said, we strongly encourage you to either use controllers or build an abstraction around this work. This behavior may change at a later date."),(0,o.kt)("p",null,"When the app starts, it will scan the ",(0,o.kt)("inlineCode",{parentName:"p"},"/views")," file directory and mount those items into the DI container."),(0,o.kt)("p",null,"For more information on how to work with views, please see the controller documentation."))}u.isMDXComponent=!0}}]);