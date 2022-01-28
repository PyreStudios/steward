"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[788],{3905:function(e,t,r){r.d(t,{Zo:function(){return p},kt:function(){return m}});var n=r(7294);function a(e,t,r){return t in e?Object.defineProperty(e,t,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[t]=r,e}function o(e,t){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),r.push.apply(r,n)}return r}function s(e){for(var t=1;t<arguments.length;t++){var r=null!=arguments[t]?arguments[t]:{};t%2?o(Object(r),!0).forEach((function(t){a(e,t,r[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):o(Object(r)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(r,t))}))}return e}function u(e,t){if(null==e)return{};var r,n,a=function(e,t){if(null==e)return{};var r,n,a={},o=Object.keys(e);for(n=0;n<o.length;n++)r=o[n],t.indexOf(r)>=0||(a[r]=e[r]);return a}(e,t);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(n=0;n<o.length;n++)r=o[n],t.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(e,r)&&(a[r]=e[r])}return a}var i=n.createContext({}),c=function(e){var t=n.useContext(i),r=t;return e&&(r="function"==typeof e?e(t):s(s({},t),e)),r},p=function(e){var t=c(e.components);return n.createElement(i.Provider,{value:t},e.children)},l={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},d=n.forwardRef((function(e,t){var r=e.components,a=e.mdxType,o=e.originalType,i=e.parentName,p=u(e,["components","mdxType","originalType","parentName"]),d=c(r),m=a,f=d["".concat(i,".").concat(m)]||d[m]||l[m]||o;return r?n.createElement(f,s(s({ref:t},p),{},{components:r})):n.createElement(f,s({ref:t},p))}));function m(e,t){var r=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var o=r.length,s=new Array(o);s[0]=d;var u={};for(var i in t)hasOwnProperty.call(t,i)&&(u[i]=t[i]);u.originalType=e,u.mdxType="string"==typeof e?e:a,s[1]=u;for(var c=2;c<o;c++)s[c]=r[c];return n.createElement.apply(null,s)}return n.createElement.apply(null,r)}d.displayName="MDXCreateElement"},4652:function(e,t,r){r.r(t),r.d(t,{frontMatter:function(){return u},contentTitle:function(){return i},metadata:function(){return c},toc:function(){return p},default:function(){return d}});var n=r(7462),a=r(3366),o=(r(7294),r(3905)),s=["components"],u={sidebar_position:1},i="Requests",c={unversionedId:"router/requests",id:"router/requests",title:"Requests",description:"Steward handles incoming HTTP requests by mapping them to a Request class.",source:"@site/docs/router/requests.md",sourceDirName:"router",slug:"/router/requests",permalink:"/steward/docs/router/requests",editUrl:"https://github.com/facebook/docusaurus/tree/main/packages/create-docusaurus/templates/shared/docs/router/requests.md",tags:[],version:"current",sidebarPosition:1,frontMatter:{sidebar_position:1},sidebar:"tutorialSidebar",previous:{title:"Installation and Requirements",permalink:"/steward/docs/quickstart/installation-and-requirements"},next:{title:"Responses",permalink:"/steward/docs/router/responses"}},p=[{value:"Getting Values for Path Parameters",id:"getting-values-for-path-parameters",children:[],level:3}],l={toc:p};function d(e){var t=e.components,r=(0,a.Z)(e,s);return(0,o.kt)("wrapper",(0,n.Z)({},l,r,{components:t,mdxType:"MDXLayout"}),(0,o.kt)("h1",{id:"requests"},"Requests"),(0,o.kt)("p",null,"Steward handles incoming HTTP requests by mapping them to a Request class.\nThis class functions as a wrapper of the HTTPRequest from 'dart:io', but also adds additional properties that are used by the Steward framework (and exposes a few extra properties for you to leverage, too!)."),(0,o.kt)("p",null,"Most of the time, you won't need to new up a request directly as you'll let Steward handle that for you, however, you may want to instantiate requests when writing tests (and this is completely supported)."),(0,o.kt)("h3",{id:"getting-values-for-path-parameters"},"Getting Values for Path Parameters"),(0,o.kt)("p",null,"When Steward's Router processes a request, it will parse and attach certain metadata from the request for each of access. Namely, you can pull path parameters out of a request object. We'll talk more about how these get ",(0,o.kt)("em",{parentName:"p"},"into")," a request object when we cover the router, but for now, just know that you can retrieve path parameters from a request by access the ",(0,o.kt)("inlineCode",{parentName:"p"},"pathParams")," property on that request."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},"Request myRequest = getARequestFromSomewhere();\nprint(myRequest.pathParams);\n")))}d.isMDXComponent=!0}}]);