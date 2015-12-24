<%@ Page Language="vb" ValidateRequest="false" Debug="true" %>
<%@ Register TagPrefix="editor" Assembly="WYSIWYGEditor" namespace="InnovaStudio" %>

<script language="VB" runat="server">
    Sub Page_Load(Source As Object, E As EventArgs)
        
        If Not Page.IsPostBack Then
            oEdit1.Text = "<p>First Paragraph here. Lorem ipsum fierent mnesarchum ne vel, et usu posse takimata omittantur, pro ut tale erant sapientem. Et regione tibique ancillae nam. Tale modus iuvaret eu usu.</p>"
        End If
   
        'Editor Dimension
        oEdit1.Width = 850
        oEdit1.Height = 350
        
        'Add Custom Buttons
        oEdit1.ToolbarCustomButtons.Add(New CustomButton("MyCustomButton", "alert('Run custom command..')", "Caption here", "btnCustom1.gif"))

        'Toolbar Buttons Configuration
        Dim tabHome As InnovaStudio.ISTab
        Dim grpEdit1 As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit1", "", New String() {"Bold", "Italic", "Underline", "FontDialog", "ForeColor", "TextDialog", "RemoveFormat"})
        Dim grpEdit2 As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit2", "", New String() {"Bullets", "Numbering", "JustifyLeft", "JustifyCenter", "JustifyRight"})
        Dim grpEdit3 As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit3", "", New String() {"LinkDialog", "ImageDialog", "YoutubeDialog", "TableDialog", "Emoticons"})
        Dim grpEdit4 As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit4", "", New String() {"InternalLink", "CustomObject", "MyCustomButton", "CustomTag"})
        Dim grpEdit5 As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit5", "", New String() {"Undo", "Redo", "FullScreen", "SourceDialog"})
        tabHome = New InnovaStudio.ISTab("tabHome", "Home")
        tabHome.Groups.AddRange(New InnovaStudio.ISGroup() {grpEdit1, grpEdit2, grpEdit3, grpEdit4, grpEdit5})
        oEdit1.ToolbarTabs.Add(tabHome)
        
        'Define "InternalLink" & "CustomObject" buttons
        oEdit1.InternalLink = "my_custom_dialog.htm"
        oEdit1.InternalLinkWidth = 650
        oEdit1.InternalLinkHeight = 350
        oEdit1.CustomObject = "my_custom_dialog.htm"
        oEdit1.CustomObjectWidth = 650
        oEdit1.CustomObjectHeight = 350
        
        'Enable Custom File Browser
        oEdit1.fileBrowser = "/assetmanager/asset.aspx"
        
        'Apply stylesheet for the editing content
        oEdit1.Css = "styles/default.css"
                
        'Define "CustomTag" dropdown
        oEdit1.CustomTags.add(new Param("First Name","{%first_name%}"))
        oEdit1.CustomTags.add(new Param("Last Name","{%last_name%}"))
        oEdit1.CustomTags.Add(New Param("Email", "{%email%}"))
        
        'Editing mode
        'oEdit1.EditMode = EditorModeEnum.XHTML
    End Sub

    Sub Button1_Click(Source As System.Object, E As System.EventArgs)
        'Label1.Text = "<div style=""padding:0px 20px;border:#000000 1px dashed;"">" & oEdit1.Text & "</div>"
        Label1.Text = oEdit1.Text
    End Sub
</script>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">

    <link href="styles/default.css" rel="stylesheet" type="text/css" />

    <script src="scripts/common/jquery-1.7.min.js" type="text/javascript"></script>
    <script src="http://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js" type="text/javascript"></script>
    <script src="scripts/common/webfont.js" type="text/javascript"></script>

    <script src="scripts/common/fancybox13/jquery.easing-1.3.pack.js" type="text/javascript"></script>
    <script src="scripts/common/fancybox13/jquery.mousewheel-3.0.2.pack.js" type="text/javascript"></script>
    <script src="scripts/common/fancybox13/jquery.fancybox-1.3.1.pack.js" type="text/javascript"></script>
    <link href="scripts/common/fancybox13/jquery.fancybox-1.3.1.css" rel="stylesheet" type="text/css" />
    <script language="javascript" type="text/javascript">
        $(document).ready(function () {
            $('a[rel=lightbox]').fancybox();
        });
    </script>

    <style type="text/css">
        body{font:12px verdana,arial,sans-serif;background-image:url(styles/45degreee_fabric.png);line-height:23px;}
        a{color:#0000cc;font-size:12px;}
        .button {padding:10px 30px 10px 30px;    
            margin-left:2px;    
            font-size:11px;font-weight:bold;color:#000000;
            background:url('scripts/style/button.png') #EEEEEE;    
            border-top:1px solid #DDDDDD;
            border-right:1px solid #AAAAAA;
            border-bottom:1px solid #AAAAAA;
            border-left:1px solid #DDDDDD;       
            cursor:pointer;}        
        h1, h2, h3 {margin-top:40px;margin-bottom:20px;text-shadow: 1px 1px 0px rgba(255, 255, 255, 0.8);}
        h2 {text-transform:uppercase}
        h3 {font-size:14px;color:#a90000;border-bottom:#000000 1px dotted;}
    </style>

</head>
<body style="margin:50px;margin-top:20px">
   
<form id="Form1" method="post" runat="server">

<p style="border:#000000 1px dashed;padding:10px;width:500px;margin-bottom:30px"><a href="default.htm">BACK</a></p>

<h1 style="font-family:Bevan;font-size:24pt;color: rgb(191, 0, 0);">InnovaStudio Live Editor - ASP.NET Example</h1>

<div id="preview" style="width:850px;">
    <asp:label id="Label1" runat="server"/>
</div>
<div style="clear:both;"></div>
<br />

<editor:wysiwygeditor 
    Runat="server"
    scriptPath="scripts/"
    ID="oEdit1" />
<br />  
<asp:button runat="server" CssClass="button" onclick="Button1_Click" Text="SUBMIT" ID="btnSubmit" />


<h2>Documentation</h2>

<h3>Usage</h3>
<p>1. Register the Editor Control in your ASP.NET page.</p>
<pre>
        &lt;%@ Register TagPrefix="editor" Assembly="WYSIWYGEditor" namespace="InnovaStudio" %>
</pre>

<p>2. Embed the control.</p>
<pre>
        &lt;editor:wysiwygeditor ID="oEdit1" scriptPath="scripts/" Runat="server" /> 
</pre>

<p>3. Configure the Editor.</p>
<pre>
        'Editor Dimension
        oEdit1.Width = 850
        oEdit1.Height = 350

        'Toolbar Buttons Configuration
        Dim tabHome As InnovaStudio.ISTab
        Dim grpEdit1 As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit1", "", New String() {"Bold", "Italic", "Underline", "FontDialog", "ForeColor", "TextDialog", "RemoveFormat"})
        Dim grpEdit2 As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit2", "", New String() {"Bullets", "Numbering", "JustifyLeft", "JustifyCenter", "JustifyRight"})
        Dim grpEdit3 As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit3", "", New String() {"LinkDialog", "ImageDialog", "VideoDialog", "TableDialog", "Emoticons"})
        Dim grpEdit4 As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit4", "", New String() {"Undo", "Redo", "FullScreen", "SourceDialog"})
        tabHome = New InnovaStudio.ISTab("tabHome", "Home")
        tabHome.Groups.AddRange(New InnovaStudio.ISGroup() {grpEdit1, grpEdit2, grpEdit3, grpEdit4})
        oEdit1.ToolbarTabs.Add(tabHome)

        'Apply stylesheet for the editing content
        oEdit1.Css = "styles/default.css"

        'Loading content into the Editor
        oEdit1.Text = "&lt;p>First Paragraph here...&lt;/p>"
</pre>


<h3>Publishing Content</h3>
<p>
When you display/publish your content result anywhere on your web sites, please include the following:</p>

<p>1. Include the css file that you defined for editing content (using oEdit1.css = "styles/default.css").</p>
<pre>
        &lt;link href="styles/default.css" rel="stylesheet" type="text/css" />
</pre>

<p>2. Include Google Font integration scripts (in the <b>&lt;head&gt;</b> section of your web page).</p>
<pre>
        &lt;script src="scripts/common/jquery-1.7.min.js" type="text/javascript">&lt;/script>
        &lt;script src="http://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js" type="text/javascript">&lt;/script>
        &lt;script src="scripts/common/webfont.js" type="text/javascript">&lt;/script>
</pre>

<p>3. Include Windows Lightbox integration scripts (in the <b>&lt;head&gt;</b> section of your web page). 
It is required to enable 'Open Larger' feature on Flickr image inserted using the Editor.</p>
<pre>
        &lt;script src="scripts/common/fancybox13/jquery.easing-1.3.pack.js" type="text/javascript">&lt;/script>
        &lt;script src="scripts/common/fancybox13/jquery.mousewheel-3.0.2.pack.js" type="text/javascript">&lt;/script>
        &lt;script src="scripts/common/fancybox13/jquery.fancybox-1.3.1.pack.js" type="text/javascript">&lt;/script>
        &lt;link href="scripts/common/fancybox13/jquery.fancybox-1.3.1.css" rel="stylesheet" type="text/css" />
        &lt;script language="javascript" type="text/javascript">
            $(document).ready(function () {
                $('a[rel=lightbox]').fancybox();
            });
        &lt;/script>
</pre>

<h3>Using File Browser</h3>
<p>
To enable custom file browser in the Image & Link dialogs, use <b>fileBrowser</b> property.</p>
<pre>
        oEdit1.FileBrowser = "/assetmanager/asset.aspx"
</pre>

<p>
To specify folder location to browse, set the <b>base</b> variable (in asset.aspx):
</p>
<pre>
        var base = "/images";
</pre>

<p>
To disable the Upload & Delete files and Create & Delete folders features, set the <b>readonly</b> variable to <b>true</b> (in asset.aspx):
</p>
<pre>
        var readonly = true;
</pre>

<p>
Some applications require File Browser that returns full file path (eg. in Newsletter editing, etc). To enable full file path feature, set the <b>fullpath</b> variable to <b>true</b> (in asset.aspx):
</p>
<pre>
        var fullpath = true;
</pre>

<h3>Adding Custom Buttons</h3>
<p>
You can add your own custom buttons using <b>arrCustomButtons</b> property.</p>
<pre>
        'Add Custom Buttons
        oEdit1.ToolbarCustomButtons.Add(New CustomButton("MyCustomButton1", "alert('Run custom command..')", "Caption here", "btnCustom1.gif"))
        oEdit1.ToolbarCustomButtons.Add(New CustomButton("MyCustomButton2", "alert('Run custom command..')", "Caption here", "btnCustom1.gif"))

        'Toolbar Buttons Configuration
        Dim tabHome As InnovaStudio.ISTab
        Dim grpEdit1 As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit1", "", New String() {"Bold", "Italic", "Underline", "FontDialog", "ForeColor", "TextDialog", "RemoveFormat"})
        Dim grpEdit2 As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit2", "", New String() {"Bullets", "Numbering", "JustifyLeft", "JustifyCenter", "JustifyRight"})
        Dim grpEdit3 As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit3", "", New String() {"LinkDialog", "ImageDialog", "VideoDialog", "TableDialog", "Emoticons"})
        Dim grpEdit4 As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit4", "", New String() {"InternalLink", "CustomObject", "<span style="color:#c90000">MyCustomButton1</span>", "<span style="color:#c90000">MyCustomButton2</span>", "CustomTag</span>"})
        Dim grpEdit5 As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit5", "", New String() {"Undo", "Redo", "FullScreen", "SourceDialog"})
        tabHome = New InnovaStudio.ISTab("tabHome", "Home")
        tabHome.Groups.AddRange(New InnovaStudio.ISGroup() {grpEdit1, grpEdit2, grpEdit3, grpEdit4, grpEdit5})
        oEdit1.ToolbarTabs.Add(tabHome)
</pre>
Button image file is located in <b>scripts/icons/</b> folder. Use <b>btnCustom1.gif</b>, <b>btnCustom2.gif</b>, .. or create your own button image.

<h3>Adding Custom Tags Insertion</h3>
<p>
With this feature, you can insert predefined custom tags into the current Editor content. 
Custom Tag insertion is a feature that is commonly used in mailing applications or template editing in web content management systems.
</p>
<pre>
        'Toolbar Buttons Configuration
        Dim tabHome As InnovaStudio.ISTab
        Dim grpEdit1 As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit1", "", New String() {"Bold", "Italic", "Underline", "FontDialog", "ForeColor", "TextDialog", "RemoveFormat"})
        Dim grpEdit2 As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit2", "", New String() {"Bullets", "Numbering", "JustifyLeft", "JustifyCenter", "JustifyRight"})
        Dim grpEdit3 As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit3", "", New String() {"LinkDialog", "ImageDialog", "VideoDialog", "TableDialog", "Emoticons"})
        Dim grpEdit4 As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit4", "", New String() {"InternalLink", "CustomObject", "<span style="color:#c90000">CustomTag</span>"})
        Dim grpEdit5 As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit5", "", New String() {"Undo", "Redo", "FullScreen", "SourceDialog"})
        tabHome = New InnovaStudio.ISTab("tabHome", "Home")
        tabHome.Groups.AddRange(New InnovaStudio.ISGroup() {grpEdit1, grpEdit2, grpEdit3, grpEdit4, grpEdit5})
        oEdit1.ToolbarTabs.Add(tabHome)

        'Define "CustomTag" dropdown
        oEdit1.CustomTags.add(new Param("First Name","{%first_name%}"))
        oEdit1.CustomTags.add(new Param("Last Name","{%last_name%}"))
        oEdit1.CustomTags.Add(New Param("Email", "{%email%}"))
</pre>

<h3>Adding "InternalLink" & "CustomObject" buttons</h3>
<p>
This buttons are commonly used in CMS application to open file browser, internal page links, etc.
To open your own custom page, use <b>modalDialog</b> method.
</p>
<pre>
        'Toolbar Buttons Configuration
        Dim tabHome As InnovaStudio.ISTab
        Dim grpEdit1 As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit1", "", New String() {"Bold", "Italic", "Underline", "FontDialog", "ForeColor", "TextDialog", "RemoveFormat"})
        Dim grpEdit2 As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit2", "", New String() {"Bullets", "Numbering", "JustifyLeft", "JustifyCenter", "JustifyRight"})
        Dim grpEdit3 As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit3", "", New String() {"LinkDialog", "ImageDialog", "VideoDialog", "TableDialog", "Emoticons"})
        Dim grpEdit4 As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit4", "", New String() {"<span style="color:#c90000">InternalLink</span>", "<span style="color:#c90000">CustomObject</span>"})
        Dim grpEdit5 As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit5", "", New String() {"Undo", "Redo", "FullScreen", "SourceDialog"})
        tabHome = New InnovaStudio.ISTab("tabHome", "Home")
        tabHome.Groups.AddRange(New InnovaStudio.ISGroup() {grpEdit1, grpEdit2, grpEdit3, grpEdit4, grpEdit5})
        oEdit1.ToolbarTabs.Add(tabHome)
        
        'Define "InternalLink" button
        oEdit1.InternalLink = "my_custom_dialog.htm"
        oEdit1.InternalLinkWidth = 650
        oEdit1.InternalLinkHeight = 350

        'Define "CustomObject" button
        oEdit1.CustomObject = "my_custom_dialog.htm"
        oEdit1.CustomObjectWidth = 650
        oEdit1.CustomObjectHeight = 350
</pre>

<h3>Inserting HTML Content into the Editor</h3>
<p>
To insert custom html from your own custom page (opened using <b>modalDialog</b> method), use <b>insertHTML</b>.
</p>
<pre>
        var sHTML = "&lt;p>Best Wishes&lt;/p>";
        var obj = parent.oUtil.obj;
        obj.insertHTML(sHTML);
</pre>

<h3>Editing Mode</h3>
<p>
To enable full html editing, set <b>EditMode</b> property to XHTML. The default value is XHTMLBody (for editing body content only).
</p>
<pre>
        oEdit1.EditMode = EditorModeEnum.XHTML
</pre>


<h3>Inserting &lt;DIV>, &lt;P> or &lt;BR> when pressing Enter Key</h3>
<p>
You can configure the editor to insert &lt;DIV>, &lt;P> or &lt;BR> when pressing enter key.
</p>
<pre>
        oEdit1.ReturnKeyMode = 1
</pre>
<p>
Possible values are:
</p>
<ul>
    <li>0: follow browser default. 
    With this option, tag inserted when pressing Enter key is depending on browser. 
    IE8 and lower will insert P and IE9 insert DIV. Firefox always insert BR while Chrome/Safari inserts DIV.</li>
    <li>1: always insert DIV (default)</li>
    <li>2: always insert BR</li>
    <li>3: always insert P</li>
</ul>

<h3>MS Word Cleaning and Paste Text</h3>
<p>
By default, when user paste content into editing panel (using CTRL+V), editor will clean the content and remove any non html standard tags. 
This is particullary useful for paste content from other resource like MS Word. 
</p>
<p>
However you can also configure editor to remove any html tags from content pasted into editor using pasteTextOnCtrlV property:
</p>
<pre>
        oEdit1.PasteTextOnCtrlV = true
</pre>

<h3>Flickr Image Configuration</h3>
<p>
To disable Flickr Image browser:
</p>
<pre>
        oEdit1.EnableFlickr = false
</pre>
<p>
To configure default Flickr Image to browse, specify Flickr Username:
</p>
<pre>
        oEdit1.FlickrUser = "USERNAME"
</pre>

<h3>Other Options</h3>
<p>
To disable Css Buttons on the Link Dialog:
</p>
<pre>
        oEdit1.EnableCssButtons = false
</pre>
<p>
To disable "Open in a Lightbox" on the Link & Image Dialog:
</p>
<pre>
        oEdit1.EnableLightbox = false
</pre>
<p>
To disable Table Autoformat on the Table Dialog:
</p>
<pre>
        oEdit1.EnableTableAutoformat = false
</pre>
<p>
To disable Google Fonts, remove "FontDialog" from the toolbar configuration, and add "FontName" (for normal font dropdown):
</p>
<pre>
        'Toolbar Buttons Configuration
        Dim tabHome As InnovaStudio.ISTab
        Dim grpEdit1 As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit1", "", New String() {"Bold", "Italic", "Underline", <span style="color:#c90000">"FontName"</span>, "ForeColor", "TextDialog", "RemoveFormat"})
        Dim grpEdit2 As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit2", "", New String() {"Bullets", "Numbering", "JustifyLeft", "JustifyCenter", "JustifyRight"})
        Dim grpEdit3 As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit3", "", New String() {"LinkDialog", "ImageDialog", "VideoDialog", "TableDialog", "Emoticons"})
        Dim grpEdit4 As InnovaStudio.ISGroup = New InnovaStudio.ISGroup("grpEdit4", "", New String() {"Undo", "Redo", "FullScreen", "SourceDialog"})
        tabHome = New InnovaStudio.ISTab("tabHome", "Home")
        tabHome.Groups.AddRange(New InnovaStudio.ISGroup() {grpEdit1, grpEdit2, grpEdit3, grpEdit4})
        oEdit1.ToolbarTabs.Add(tabHome)
</pre>

<h3>Localization</h3>
<p>
You can localize the Editor to be displayed in specific language by setting <b>Language</b> property:
</p>
<pre>
    &lt;editor:wysiwygeditor
        Runat="server"
        scriptPath="scripts/"
        <span style="color:#c90000">Language="da-DK"</span>
        Content="Hello World!"
        ID="oEdit1" />
</pre>
<p>
The current available values for Language property are: da-DK (Danish), nl-NL (Dutch), fi-FI (Finnish), fr-FR (French), de-DE (German), 
zh-CHS (Chinese Simplified), zh-CHT (Chinese Traditional), nn-NO (Norwegian), es-ES (Spanish), sv-SE (Swedish). it-IT (Italian). 
If Language property is not specified, English (en-US) version will be displayed.
</p>
<p>
<b>Note: </b>
<ul>
<li>Most of the available translations are not complete yet. </li>
<li>To translate the Editor into your language, open & edit language files in folder: <br />
- scripts\language\<br />
- scripts\common\language\
</li>
</ul>
</p>

<h3>List of Available Toolbar Buttons</h3>
<ul>
<li>Bold</li>
<li>Italic</li>
<li>Underline</li>
<li>Strikethrough</li>
<li>Superscript</li>
<li>Subscript</li>
<li>ForeColor</li>
<li>BackColor</li>
<li>RemoveFormat</li>
<li>Paragraph</li>
<li>FontName</li>
<li>FontSize</li>
<li>FontDialog</li>
<li>TextDialog</li>
<li>CompleteTextDialog &nbsp;<i style="color:blue">(NEW!)</i></li>
<li>Quote &nbsp;<i style="color:blue">(NEW!)</i></li>
<li>Styles <i>(Style Selection)</i></li>
<li>JustifyLeft</li>
<li>JustifyCenter</li>
<li>JustifyRight</li>
<li>JustifyFull</li>
<li>Bullets</li>
<li>Numbering</li>
<li>Indent</li>
<li>Outdent</li>
<li>TableDialog</li>
<li>FlashDialog</li>
<li>LinkDialog</li>
<li>ImageDialog</li>
<li>YoutubeDialog</li>
<li>CharsDialog <i>(Special Characters Dialog)</i></li>
<li>SearchDialog</li>
<li>SourceDialog <i>(HTML Editor Dialog)</i></li>
<li>Emoticons</li>
<li>Line</li>
<li>InternalLink <i>(Custom)</i></li>
<li>CustomObject <i>(Custom)</i></li>
<li>CustomTag <i>(Custom)</i></li>
<li>Undo</li>
<li>Redo</li>
<li>FullScreen</li>
<li>BRK <i>(Line Break)</i></li>
</ul>

<br />
<hr />
<div style="font-size:11px">Copyright © 2012, INNOVASTUDIO (www.InnovaStudio.com). All rights reserved.</div>


</form>

</body>
</html>