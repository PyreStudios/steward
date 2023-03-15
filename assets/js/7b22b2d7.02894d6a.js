"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[554],{3905:(e,t,r)=>{r.d(t,{Zo:()=>u,kt:()=>f});var a=r(7294);function n(e,t,r){return t in e?Object.defineProperty(e,t,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[t]=r,e}function s(e,t){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);t&&(a=a.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),r.push.apply(r,a)}return r}function o(e){for(var t=1;t<arguments.length;t++){var r=null!=arguments[t]?arguments[t]:{};t%2?s(Object(r),!0).forEach((function(t){n(e,t,r[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):s(Object(r)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(r,t))}))}return e}function i(e,t){if(null==e)return{};var r,a,n=function(e,t){if(null==e)return{};var r,a,n={},s=Object.keys(e);for(a=0;a<s.length;a++)r=s[a],t.indexOf(r)>=0||(n[r]=e[r]);return n}(e,t);if(Object.getOwnPropertySymbols){var s=Object.getOwnPropertySymbols(e);for(a=0;a<s.length;a++)r=s[a],t.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(e,r)&&(n[r]=e[r])}return n}var c=a.createContext({}),l=function(e){var t=a.useContext(c),r=t;return e&&(r="function"==typeof e?e(t):o(o({},t),e)),r},u=function(e){var t=l(e.components);return a.createElement(c.Provider,{value:t},e.children)},d={inlineCode:"code",wrapper:function(e){var t=e.children;return a.createElement(a.Fragment,{},t)}},p=a.forwardRef((function(e,t){var r=e.components,n=e.mdxType,s=e.originalType,c=e.parentName,u=i(e,["components","mdxType","originalType","parentName"]),p=l(r),f=n,m=p["".concat(c,".").concat(f)]||p[f]||d[f]||s;return r?a.createElement(m,o(o({ref:t},u),{},{components:r})):a.createElement(m,o({ref:t},u))}));function f(e,t){var r=arguments,n=t&&t.mdxType;if("string"==typeof e||n){var s=r.length,o=new Array(s);o[0]=p;var i={};for(var c in t)hasOwnProperty.call(t,c)&&(i[c]=t[c]);i.originalType=e,i.mdxType="string"==typeof e?e:n,o[1]=i;for(var l=2;l<s;l++)o[l]=r[l];return a.createElement.apply(null,o)}return a.createElement.apply(null,r)}p.displayName="MDXCreateElement"},8408:(e,t,r)=>{r.r(t),r.d(t,{assets:()=>c,contentTitle:()=>o,default:()=>d,frontMatter:()=>s,metadata:()=>i,toc:()=>l});var a=r(3117),n=(r(7294),r(3905));const s={sidebar_position:5},o="Static Assets",i={unversionedId:"router/static_assets",id:"router/static_assets",title:"Static Assets",description:"Steward also offers static asset handlers for serving files that do not change based on server requests. Commonly, image files, html pages, and more are served as static assets. If you are using view templating, those templates are not static assets and should not be served this way.",source:"@site/docs/router/static_assets.md",sourceDirName:"router",slug:"/router/static_assets",permalink:"/steward/docs/router/static_assets",draft:!1,editUrl:"https://github.com/pyrestudios/steward/tree/main/docs/router/static_assets.md",tags:[],version:"current",sidebarPosition:5,frontMatter:{sidebar_position:5},sidebar:"tutorialSidebar",previous:{title:"Middleware",permalink:"/steward/docs/router/middleware"},next:{title:"What is a Container",permalink:"/steward/docs/container/what_is_a_container"}},c={},l=[],u={toc:l};function d(e){let{components:t,...r}=e;return(0,n.kt)("wrapper",(0,a.Z)({},u,r,{components:t,mdxType:"MDXLayout"}),(0,n.kt)("h1",{id:"static-assets"},"Static Assets"),(0,n.kt)("p",null,"Steward also offers static asset handlers for serving files that do not change based on server requests. Commonly, image files, html pages, and more are served as static assets. If you are using view templating, those templates are ",(0,n.kt)("em",{parentName:"p"},"not")," static assets and should not be served this way."),(0,n.kt)("pre",null,(0,n.kt)("code",{parentName:"pre",className:"language-dart"},"final router = Router();\nrouter.staticFiles('/static');\n")),(0,n.kt)("p",null,"Additionally, you can use middleware with static file handling."),(0,n.kt)("pre",null,(0,n.kt)("code",{parentName:"pre",className:"language-dart"},"final router = Router();\nrouter.staticFiles('/private-assets', middleware: [RequireAuthMiddleware]);\n")))}d.isMDXComponent=!0}}]);