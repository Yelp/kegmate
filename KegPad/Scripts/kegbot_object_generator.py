#!/usr/bin/python
# -*- coding: utf-8 -*-

import xml.dom.minidom
import pprint
import codecs

export_dir = '/Users/johnb/Desktop/export/'
class_prefix = 'KBRK'

# A few things need to be cleaned up in the html to make it true xml
# need to remove formats from the middle of <p> and <td> blocks mainly
html = """
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
 
<html xmlns="http://www.w3.org/1999/xhtml"> 
  <head> 
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
    
    <title>Kegbot Data Model Reference &mdash; Kegbot Project v0.7 documentation</title> 
    <link rel="stylesheet" href="../_static/default.css" type="text/css" /> 
    <link rel="stylesheet" href="../_static/pygments.css" type="text/css" /> 
    <script type="text/javascript"> 
      var DOCUMENTATION_OPTIONS = {
        URL_ROOT:    '../',
        VERSION:     '0.7',
        COLLAPSE_INDEX: false,
        FILE_SUFFIX: '.html',
        HAS_SOURCE:  true
      };
    </script> 
    <script type="text/javascript" src="../_static/jquery.js"></script> 
    <script type="text/javascript" src="../_static/underscore.js"></script> 
    <script type="text/javascript" src="../_static/doctools.js"></script> 
    <link rel="top" title="Kegbot Project v0.7 documentation" href="../index.html" /> 
    <link rel="up" title="Kegbot API Guide" href="index.html" /> 
    <link rel="next" title="Developer Notes" href="../developer-notes/index.html" /> 
    <link rel="prev" title="Kegbot Web API" href="web-api.html" /> 
  </head> 
  <body> 
    <div class="related"> 
      <h3>Navigation</h3> 
      <ul> 
        <li class="right" style="margin-right: 10px"> 
          <a href="../genindex.html" title="General Index"
             accesskey="I">index</a></li> 
        <li class="right" > 
          <a href="../developer-notes/index.html" title="Developer Notes"
             accesskey="N">next</a> |</li> 
        <li class="right" > 
          <a href="web-api.html" title="Kegbot Web API"
             accesskey="P">previous</a> |</li> 
        <li><a href="../index.html">Kegbot Project v0.7 documentation</a> &raquo;</li> 
          <li><a href="index.html" accesskey="U">Kegbot API Guide</a> &raquo;</li> 
      </ul> 
    </div>  
 
    <div class="document"> 
      <div class="documentwrapper"> 
        <div class="bodywrapper"> 
          <div class="body"> 
            
  <div class="section" id="kegbot-data-model-reference"> 
<span id="data-model"></span><h1>Kegbot Data Model Reference<a class="headerlink" href="#kegbot-data-model-reference" title="Permalink to this headline">¶</a></h1> 
<p>This document contains a reference of the most commonly used objects in the API.</p> 
<div class="section" id="object-types"> 
<span id="api-objects"></span><h2>Object Types<a class="headerlink" href="#object-types" title="Permalink to this headline">¶</a></h2> 
<div class="section" id="authtoken"> 
<span id="model-authtoken"></span><h3>AuthToken<a class="headerlink" href="#authtoken" title="Permalink to this headline">¶</a></h3> 
<p>An AuthToken object represents a unique key that identifies a user.</p> 
<table border="1" class="docutils"> 
<colgroup> 
<col width="26%" /> 
<col width="18%" /> 
<col width="55%" /> 
</colgroup> 
<thead valign="bottom"> 
<tr><th class="head">Property</th> 
<th class="head">Type</th> 
<th class="head">Description</th> 
</tr> 
</thead> 
<tbody valign="top"> 
<tr><td>id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>An opaque, unique identifier for this
object.</td> 
</tr> 
<tr><td>auth_device</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>The name of the authentication device
owning this token (for example,
<em>&#8220;onewire&#8221;</em>).</td> 
</tr> 
<tr><td>token_value</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>The device-specific token value.  For
instance, on onewire devices, the token
value will be a hexadecimal string giving
the unique 64-bit id.</td> 
</tr> 
<tr><td>username</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>The username the token is bound to, or
null if the token is unassigned.</td> 
</tr> 
<tr><td>nice_name</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>An admin-configurable &#8220;nice name&#8221;, or
alias, for this token instance. May be
null if the token does not have a nice
name.</td> 
</tr> 
<tr><td>enabled</td> 
<td><tt class="docutils literal"><span class="pre">bool</span></tt></td> 
<td>Whether the token is active.</td> 
</tr> 
<tr><td>created_time</td> 
<td><tt class="docutils literal"><span class="pre">date</span></tt></td> 
<td>The date the token was created or
activated.</td> 
</tr> 
<tr><td>expire_time</td> 
<td><tt class="docutils literal"><span class="pre">date</span></tt></td> 
<td>The date after which the token is no
longer valid, or null if there is no
expiration.</td> 
</tr> 
</tbody> 
</table> 
</div> 
<div class="section" id="beerstyle"> 
<span id="model-beerstyle"></span><h3>BeerStyle<a class="headerlink" href="#beerstyle" title="Permalink to this headline">¶</a></h3> 
<p>A BeerStyle describes a particular style of beer.</p> 
<table border="1" class="docutils"> 
<colgroup> 
<col width="26%" /> 
<col width="18%" /> 
<col width="55%" /> 
</colgroup> 
<thead valign="bottom"> 
<tr><th class="head">Property</th> 
<th class="head">Type</th> 
<th class="head">Description</th> 
</tr> 
</thead> 
<tbody valign="top"> 
<tr><td>id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>An opaque, unique identifier for this
object.</td> 
</tr> 
<tr><td>name</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>The name of this beer style.</td> 
</tr> 
</tbody> 
</table> 
</div> 
<div class="section" id="beertype"> 
<span id="model-beertype"></span><h3>BeerType<a class="headerlink" href="#beertype" title="Permalink to this headline">¶</a></h3> 
<p>A BeerType identifies a specific beer, produced by a specific
Brewer, and often in a particular BeerStyle.  Several
traits of the beer, such as its alcohol content, may also be given.</p> 
<table border="1" class="docutils"> 
<colgroup> 
<col width="26%" /> 
<col width="18%" /> 
<col width="55%" /> 
</colgroup> 
<thead valign="bottom"> 
<tr><th class="head">Property</th> 
<th class="head">Type</th> 
<th class="head">Description</th> 
</tr> 
</thead> 
<tbody valign="top"> 
<tr><td>id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>An opaque, unique identifier for this
object.</td> 
</tr> 
<tr><td>name</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>The brand name of the beer.</td> 
</tr> 
<tr><td>brewer_id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>The identifier for the Brewer 
which produces this beer.</td> 
</tr> 
<tr><td>style_id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>The identifier for the style of this beer.</td> 
</tr> 
<tr><td>edition</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>For seasonal or special edition version of
a beers, the year or other indicative
name; null otherwise.</td> 
</tr> 
<tr><td>calories_oz</td> 
<td><tt class="docutils literal"><span class="pre">float</span></tt></td> 
<td>The number of calories per fluid ounce of
beer, or null if not known.</td> 
</tr> 
<tr><td>carbs_oz</td> 
<td><tt class="docutils literal"><span class="pre">float</span></tt></td> 
<td>Number of carbohydrates per ounce of
beer, or null if not known.</td> 
</tr> 
<tr><td>abv</td> 
<td><tt class="docutils literal"><span class="pre">float</span></tt></td> 
<td>Alcohol by volume, as as percentage value
between 0.0 and 100.0, or null if not
known.</td> 
</tr> 
<tr><td>original_gravity</td> 
<td><tt class="docutils literal"><span class="pre">float</span></tt></td> 
<td>Original gravity of this beer, or null 
if not known.</td> 
</tr> 
<tr><td>specific_gravity</td> 
<td><tt class="docutils literal"><span class="pre">float</span></tt></td> 
<td>Specific gravity of this beer, or null 
if not known.</td> 
</tr> 
</tbody> 
</table> 
</div> 
<div class="section" id="brewer"> 
<span id="model-brewer"></span><h3>Brewer<a class="headerlink" href="#brewer" title="Permalink to this headline">¶</a></h3> 
<p>A Brewer is a producer of beer.</p> 
<table border="1" class="docutils"> 
<colgroup> 
<col width="26%" /> 
<col width="18%" /> 
<col width="55%" /> 
</colgroup> 
<thead valign="bottom"> 
<tr><th class="head">Property</th> 
<th class="head">Type</th> 
<th class="head">Description</th> 
</tr> 
</thead> 
<tbody valign="top"> 
<tr><td>id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>An opaque, unique identifier for this
object.</td> 
</tr> 
<tr><td>name</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>Name of the brewer</td> 
</tr> 
<tr><td>country</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>Country where the brewer is based; may be
an empty string.</td> 
</tr> 
<tr><td>origin_state</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>State or province where the brewer is
based; may be an empty string.</td> 
</tr> 
<tr><td>origin_city</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>City where the brewer is based; may be an
empty string.</td> 
</tr> 
<tr><td>production</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>Type of production, either &#8220;commercial&#8221; or
&#8220;homebrew&#8221;; may be an empty string.</td> 
</tr> 
<tr><td>url</td> 
<td><tt class="docutils literal"><span class="pre">url</span></tt></td> 
<td>Homepage of the brewer; may be an empty
string.</td> 
</tr> 
<tr><td>description</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>Free-form description of the brewer; may
be an empty string.</td> 
</tr> 
</tbody> 
</table> 
</div> 
<div class="section" id="drink"> 
<span id="model-drink"></span><h3>Drink<a class="headerlink" href="#drink" title="Permalink to this headline">¶</a></h3> 
<p>Drink objects represent a specific pour.  Typically, but not always, the Drink
object lists the user known to have poured it, as well as the keg from which it
came.</p> 
<table border="1" class="docutils"> 
<colgroup> 
<col width="26%" /> 
<col width="18%" /> 
<col width="55%" /> 
</colgroup> 
<thead valign="bottom"> 
<tr><th class="head">Property</th> 
<th class="head">Type</th> 
<th class="head">Description</th> 
</tr> 
</thead> 
<tbody valign="top"> 
<tr><td>id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>An opaque, unique identifier for this
object.</td> 
</tr> 
<tr><td>ticks</td> 
<td><tt class="docutils literal"><span class="pre">uint32</span></tt></td> 
<td>The number of flow meter ticks recorded
for this drink.  Note that this value
should never change once set, regardless
of the volume_ml property.</td> 
</tr> 
<tr><td>volume_ml</td> 
<td><tt class="docutils literal"><span class="pre">float</span></tt></td> 
<td>The volume of the pour, in milliliters.</td> 
</tr> 
<tr><td>session_id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>Session that this drink
belongs to.</td> 
</tr> 
<tr><td>pour_time</td> 
<td><tt class="docutils literal"><span class="pre">date</span></tt></td> 
<td>The date of the pour.</td> 
</tr> 
<tr><td>duration</td> 
<td><tt class="docutils literal"><span class="pre">int</span></tt></td> 
<td>The duration of the pour, in seconds, or
null if not known.</td> 
</tr> 
<tr><td>status</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>The status of the drink: one of &#8220;valid&#8221; or
&#8220;invalid&#8221;.</td> 
</tr> 
<tr><td>keg_id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>The Keg from which the drink
was poured, or null if not known.</td> 
</tr> 
<tr><td>user_id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>The User who poured the
drink, or null if not known.</td> 
</tr> 
<tr><td>auth_token_id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>The AuthToken used to pour
the drink, or null if not known.</td> 
</tr> 
</tbody> 
</table> 
</div> 
<div class="section" id="keg"> 
<span id="model-keg"></span><h3>Keg<a class="headerlink" href="#keg" title="Permalink to this headline">¶</a></h3> 
<p>A Keg object records an instance of a particular type and quantity of beer.  In
a running system, a Keg will be instantiated and linked to an active
KegTap.  A Drink recorded against that tap deducts
from the known remaining volume.</p> 
<table border="1" class="docutils"> 
<colgroup> 
<col width="26%" /> 
<col width="18%" /> 
<col width="55%" /> 
</colgroup> 
<thead valign="bottom"> 
<tr><th class="head">Property</th> 
<th class="head">Type</th> 
<th class="head">Description</th> 
</tr> 
</thead> 
<tbody valign="top"> 
<tr><td>id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>An opaque, unique identifier for this
object.</td> 
</tr> 
<tr><td>type_id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>The BeerType for this beer.</td> 
</tr> 
<tr><td>size_id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>The KegSize of this keg.</td> 
</tr> 
<tr><td>size_name</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>The name of the KegSize of
this keg.</td> 
</tr> 
<tr><td>size_volume_ml</td> 
<td><tt class="docutils literal"><span class="pre">float</span></tt></td> 
<td>The total volume, in milliliters, for the
KegSize of this keg.</td> 
</tr> 
<tr><td>volume_ml_remain</td> 
<td><tt class="docutils literal"><span class="pre">float</span></tt></td> 
<td>The total volume remaining, in
milliliters.</td> 
</tr> 
<tr><td>percent_full</td> 
<td><tt class="docutils literal"><span class="pre">float</span></tt></td> 
<td>The total volume remaining, as a
percentage value between 0.0 and 100.0.</td> 
</tr> 
<tr><td>started_time</td> 
<td><tt class="docutils literal"><span class="pre">date</span></tt></td> 
<td>The time when the keg was first started,
or tapped.</td> 
</tr> 
<tr><td>finished_time</td> 
<td><tt class="docutils literal"><span class="pre">date</span></tt></td> 
<td>The time when the keg was finished, or
emptied.  This value is undefined if the
keg&#8217;s status is not &#8220;offline&#8221;.</td> 
</tr> 
<tr><td>status</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>Current status of the keg; either &#8220;online&#8221;
or &#8220;offline&#8221;.</td> 
</tr> 
<tr><td>description</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>A site-specific description of this keg,
or null if not known.</td> 
</tr> 
<tr><td>spilled_ml</td> 
<td><tt class="docutils literal"><span class="pre">float</span></tt></td> 
<td>Total volume marked as spilled, in
milliliters.</td> 
</tr> 
</tbody> 
</table> 
</div> 
<div class="section" id="kegsize"> 
<span id="model-kegsize"></span><h3>KegSize<a class="headerlink" href="#kegsize" title="Permalink to this headline">¶</a></h3> 
<p>A KegSize is a small object that gives a name and a volume to a particular
quantity.</p> 
<table border="1" class="docutils"> 
<colgroup> 
<col width="26%" /> 
<col width="18%" /> 
<col width="55%" /> 
</colgroup> 
<thead valign="bottom"> 
<tr><th class="head">Property</th> 
<th class="head">Type</th> 
<th class="head">Description</th> 
</tr> 
</thead> 
<tbody valign="top"> 
<tr><td>id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>An opaque, unique identifier for this
object.</td> 
</tr> 
<tr><td>name</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>Name of this size.</td> 
</tr> 
<tr><td>volume_ml</td> 
<td><tt class="docutils literal"><span class="pre">float</span></tt></td> 
<td>Total volume of this size, in
milliliters.</td> 
</tr> 
</tbody> 
</table> 
</div> 
<div class="section" id="kegtap"> 
<span id="model-kegtap"></span><h3>KegTap<a class="headerlink" href="#kegtap" title="Permalink to this headline">¶</a></h3> 
<p>Every available beer tap in the system is modeled by a KegTap.</p> 
<table border="1" class="docutils"> 
<colgroup> 
<col width="26%" /> 
<col width="18%" /> 
<col width="55%" /> 
</colgroup> 
<thead valign="bottom"> 
<tr><th class="head">Property</th> 
<th class="head">Type</th> 
<th class="head">Description</th> 
</tr> 
</thead> 
<tbody valign="top"> 
<tr><td>id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>An opaque, unique identifier for this
object.</td> 
</tr> 
<tr><td>name</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>A short, descriptive name for the tap.</td> 
</tr> 
<tr><td>meter_name</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>The name of the flow meter that is
assigned to this tap.</td> 
</tr> 
<tr><td>ml_per_tick</td> 
<td><tt class="docutils literal"><span class="pre">float</span></tt></td> 
<td>Volume to record per tick of the
corresponding flow meter, in milliliters.</td> 
</tr> 
<tr><td>description</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>A longer description of the tap, or
null if not known.</td> 
</tr> 
<tr><td>current_keg_id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>The Keg currently assigned to
the tap, or null.</td> 
</tr> 
<tr><td>thermo_sensor_id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>The ThermoSensor assigned to
the tap, or null.</td> 
</tr> 
<tr><td>last_temperature</td> 
<td><tt class="docutils literal"><span class="pre">float`</span></tt></td> 
<td>The last recorded temperature of the
attached temperature sensor, in degrees C,
or null if no sensor configured.</td> 
</tr> 
</tbody> 
</table> 
</div> 
<div class="section" id="session"> 
<span id="model-session"></span><h3>Session<a class="headerlink" href="#session" title="Permalink to this headline">¶</a></h3> 
<p>A Session is used to group drinks that are close to eachother in time.  Every
Drink is assigned to a session.</p> 
<table border="1" class="docutils"> 
<colgroup> 
<col width="26%" /> 
<col width="18%" /> 
<col width="55%" /> 
</colgroup> 
<thead valign="bottom"> 
<tr><th class="head">Property</th> 
<th class="head">Type</th> 
<th class="head">Description</th> 
</tr> 
</thead> 
<tbody valign="top"> 
<tr><td>id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>An opaque, unique identifier for this
object.</td> 
</tr> 
<tr><td>start_time</td> 
<td><tt class="docutils literal"><span class="pre">date</span></tt></td> 
<td>The time of the first Drink 
in the session.</td> 
</tr> 
<tr><td>end_time</td> 
<td><tt class="docutils literal"><span class="pre">date</span></tt></td> 
<td>The time of the last (most recent)
Drink in the session.</td> 
</tr> 
<tr><td>volume_ml</td> 
<td><tt class="docutils literal"><span class="pre">float</span></tt></td> 
<td>Total volume poured, among all drinks in
the session.</td> 
</tr> 
<tr><td>name</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>A descriptive name for the session; may be
empty if no name has been set.</td> 
</tr> 
<tr><td>slug</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>A variation of the <tt class="docutils literal"><span class="pre">name</span></tt> field; may be
empty if no name has been set.</td> 
</tr> 
</tbody> 
</table> 
</div> 
<div class="section" id="system-event"> 
<span id="model-systemevent"></span><h3>System Event<a class="headerlink" href="#system-event" title="Permalink to this headline">¶</a></h3> 
<p>This object describes a system-wide event. System events are generated in
response to drink and keg configuration activity.</p> 
<table border="1" class="docutils"> 
<colgroup> 
<col width="26%" /> 
<col width="18%" /> 
<col width="55%" /> 
</colgroup> 
<thead valign="bottom"> 
<tr><th class="head">Property</th> 
<th class="head">Type</th> 
<th class="head">Description</th> 
</tr> 
</thead> 
<tbody valign="top"> 
<tr><td>id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>An opaque, unique identifier for this
object.</td> 
</tr> 
<tr><td>type</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>The type of system event.
Currently-defined event types:
drink_poured, session_started,
session_joined, keg_tapped, keg_ended.</td> 
</tr> 
<tr><td>time</td> 
<td><tt class="docutils literal"><span class="pre">date</span></tt></td> 
<td>The time of the event.</td> 
</tr> 
<tr><td>drink_id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>The Drink that this event
concerns; may be null.</td> 
</tr> 
<tr><td>keg_id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>The Keg that this event
concerns; may be null.</td> 
</tr> 
<tr><td>session_id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>The Session that this event
concerns; may be null.</td> 
</tr> 
<tr><td>user_id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>The User that this event
concerns; may be null.</td> 
</tr> 
</tbody> 
</table> 
</div> 
<div class="section" id="thermolog"> 
<span id="model-thermolog"></span><h3>ThermoLog<a class="headerlink" href="#thermolog" title="Permalink to this headline">¶</a></h3> 
<p>Temperature sensors emit periodic data, which are recorded as ThermoLog records.</p> 
<table border="1" class="docutils"> 
<colgroup> 
<col width="26%" /> 
<col width="18%" /> 
<col width="55%" /> 
</colgroup> 
<thead valign="bottom"> 
<tr><th class="head">Property</th> 
<th class="head">Type</th> 
<th class="head">Description</th> 
</tr> 
</thead> 
<tbody valign="top"> 
<tr><td>id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>An opaque, unique identifier for this
object.</td> 
</tr> 
<tr><td>sensor_id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>The ThermoSensor which
recorded the entry.</td> 
</tr> 
<tr><td>temperature_c</td> 
<td><tt class="docutils literal"><span class="pre">float</span></tt></td> 
<td>Temperature, in degrees celcius.</td> 
</tr> 
<tr><td>record_time</td> 
<td><tt class="docutils literal"><span class="pre">date</span></tt></td> 
<td>Time of recording.</td> 
</tr> 
</tbody> 
</table> 
</div> 
<div class="section" id="thermosensor"> 
<span id="model-thermosensor"></span><h3>ThermoSensor<a class="headerlink" href="#thermosensor" title="Permalink to this headline">¶</a></h3> 
<p>Represents a temperature sensor in the Kegbot system.</p> 
<table border="1" class="docutils"> 
<colgroup> 
<col width="26%" /> 
<col width="18%" /> 
<col width="55%" /> 
</colgroup> 
<thead valign="bottom"> 
<tr><th class="head">Property</th> 
<th class="head">Type</th> 
<th class="head">Description</th> 
</tr> 
</thead> 
<tbody valign="top"> 
<tr><td>id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>An opaque, unique identifier for this
object.</td> 
</tr> 
<tr><td>sensor_name</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>The raw and unique name for the sensor.</td> 
</tr> 
<tr><td>nice_name</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>A human-readable, descriptive name for the
sensor.</td> 
</tr> 
</tbody> 
</table> 
</div> 
<div class="section" id="user"> 
<span id="model-user"></span><h3>User<a class="headerlink" href="#user" title="Permalink to this headline">¶</a></h3> 
<p>This object models a User in the system.</p> 
<table border="1" class="docutils"> 
<colgroup> 
<col width="26%" /> 
<col width="18%" /> 
<col width="55%" /> 
</colgroup> 
<thead valign="bottom"> 
<tr><th class="head">Property</th> 
<th class="head">Type</th> 
<th class="head">Description</th> 
</tr> 
</thead> 
<tbody valign="top"> 
<tr><td>username</td> 
<td><tt class="docutils literal"><span class="pre">username</span></tt></td> 
<td>Unique identifier for the user.</td> 
</tr> 
<tr><td>mugshot_url</td> 
<td><tt class="docutils literal"><span class="pre">url</span></tt></td> 
<td>URL to the mugshot for this user.</td> 
</tr> 
<tr><td>is_active</td> 
<td><tt class="docutils literal"><span class="pre">bool</span></tt></td> 
<td>True if this is an active user.</td> 
</tr> 
</tbody> 
</table> 
</div> 
<div class="section" id="usersession"> 
<span id="model-usersession"></span><h3>UserSession<a class="headerlink" href="#usersession" title="Permalink to this headline">¶</a></h3> 
<p>A UserSession describe&#8217;s a particular user&#8217;s contribution to a
Session, for a particular Keg.</p> 
<table border="1" class="docutils"> 
<colgroup> 
<col width="26%" /> 
<col width="18%" /> 
<col width="55%" /> 
</colgroup> 
<thead valign="bottom"> 
<tr><th class="head">Property</th> 
<th class="head">Type</th> 
<th class="head">Description</th> 
</tr> 
</thead> 
<tbody valign="top"> 
<tr><td>id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>An opaque, unique identifier for this
object.</td> 
</tr> 
<tr><td>session_id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>The Session that was
contributed to.</td> 
</tr> 
<tr><td>username</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>The User.</td> 
</tr> 
<tr><td>keg_id</td> 
<td><tt class="docutils literal"><span class="pre">string</span></tt></td> 
<td>The Keg that was contributed
to.</td> 
</tr> 
<tr><td>start_time</td> 
<td><tt class="docutils literal"><span class="pre">date</span></tt></td> 
<td>Time of the user&#8217;s first activity.</td> 
</tr> 
<tr><td>end_time</td> 
<td><tt class="docutils literal"><span class="pre">date</span></tt></td> 
<td>Time of the user&#8217;s last activity.</td> 
</tr> 
<tr><td>volume_ml</td> 
<td><tt class="docutils literal"><span class="pre">float</span></tt></td> 
<td>Total volume poured by this user in the
session.</td> 
</tr> 
</tbody> 
</table> 
</div> 
</div> 
</div> 
 
 
          </div> 
        </div> 
      </div> 
      <div class="sphinxsidebar"> 
        <div class="sphinxsidebarwrapper"> 
  <h3><a href="../index.html">Table Of Contents</a></h3> 
  <ul> 
<li><a class="reference internal" href="#">Kegbot Data Model Reference</a><ul> 
<li><a class="reference internal" href="#object-types">Object Types</a><ul> 
<li><a class="reference internal" href="#authtoken">AuthToken</a></li> 
<li><a class="reference internal" href="#beerstyle">BeerStyle</a></li> 
<li><a class="reference internal" href="#beertype">BeerType</a></li> 
<li><a class="reference internal" href="#brewer">Brewer</a></li> 
<li><a class="reference internal" href="#drink">Drink</a></li> 
<li><a class="reference internal" href="#keg">Keg</a></li> 
<li><a class="reference internal" href="#kegsize">KegSize</a></li> 
<li><a class="reference internal" href="#kegtap">KegTap</a></li> 
<li><a class="reference internal" href="#session">Session</a></li> 
<li><a class="reference internal" href="#system-event">System Event</a></li> 
<li><a class="reference internal" href="#thermolog">ThermoLog</a></li> 
<li><a class="reference internal" href="#thermosensor">ThermoSensor</a></li> 
<li><a class="reference internal" href="#user">User</a></li> 
<li><a class="reference internal" href="#usersession">UserSession</a></li> 
</ul> 
</li> 
</ul> 
</li> 
</ul> 
 
  <h4>Previous topic</h4> 
  <p class="topless"><a href="web-api.html"
                        title="previous chapter">Kegbot Web API</a></p> 
  <h4>Next topic</h4> 
  <p class="topless"><a href="../developer-notes/index.html"
                        title="next chapter">Developer Notes</a></p> 
  <h3>This Page</h3> 
  <ul class="this-page-menu"> 
    <li><a href="../_sources/api/data-model.txt"
           rel="nofollow">Show Source</a></li> 
  </ul> 
<div id="searchbox" style="display: none"> 
  <h3>Quick search</h3> 
    <form class="search" action="../search.html" method="get"> 
      <input type="text" name="q" size="18" /> 
      <input type="submit" value="Go" /> 
      <input type="hidden" name="check_keywords" value="yes" /> 
      <input type="hidden" name="area" value="default" /> 
    </form> 
    <p class="searchtip" style="font-size: 90%"> 
    Enter search terms or a module, class or function name.
    </p> 
</div> 
<script type="text/javascript">$('#searchbox').show(0);</script> 
        </div> 
      </div> 
      <div class="clearer"></div> 
    </div> 
    <div class="related"> 
      <h3>Navigation</h3> 
      <ul> 
        <li class="right" style="margin-right: 10px"> 
          <a href="../genindex.html" title="General Index"
             >index</a></li> 
        <li class="right" > 
          <a href="../developer-notes/index.html" title="Developer Notes"
             >next</a> |</li> 
        <li class="right" > 
          <a href="web-api.html" title="Kegbot Web API"
             >previous</a> |</li> 
        <li><a href="../index.html">Kegbot Project v0.7 documentation</a> &raquo;</li> 
          <li><a href="index.html" >Kegbot API Guide</a> &raquo;</li> 
      </ul> 
    </div> 
    <div class="footer"> 
        &copy; Copyright 2010, mike wakerly.
      Created using <a href="http://sphinx.pocoo.org/">Sphinx</a> 1.0.7.
    </div> 
  </body> 
</html>
"""

private_header_template = """//
//  _%(name)s.h
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//
//  %(comment)s

#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

@interface _%(name)s : RKObject {
%(instance_vars)s}

%(property_declarations)s
@end
"""


private_source_template = """//
//  _%(name)s.m
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//

#import "_%(name)s.h"


@implementation _%(name)s

%(synthesize)s
#pragma mark RKObjectMappable methods

+ (NSDictionary*)elementToPropertyMappings {
  return [NSDictionary dictionaryWithKeysAndObjects:
%(element_to_property)s          nil];
}

#pragma mark -

- (void)dealloc {
%(releases)s  [super dealloc];
}

@end"""

private_managed_header_template = """//
//  _%(name)s.h
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//
//  %(comment)s

#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

@interface _%(name)s : RKManagedObject { }

%(property_declarations)s
@end
"""


private_managed_source_template = """//
//  _%(name)s.m
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//

#import "_%(name)s.h"


@implementation _%(name)s

%(dynamic)s
#pragma mark RKObjectMappable methods

+ (NSDictionary*)elementToPropertyMappings {
  return [NSDictionary dictionaryWithKeysAndObjects:
%(element_to_property)s          nil];
}

+ (NSString*)primaryKeyProperty {
  return @"identifier";
}

#pragma mark -

@end"""

header_template = """//
//  %(name)s.h
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//
//  %(comment)s

#import "_%(name)s.h"

@interface %(name)s : _%(name)s { }

@end
"""

source_template = """//
//  %(name)s.m
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//

#import "%(name)s.h"


@implementation %(name)s

@end"""

def xmltodict(xmlstring):
	doc = xml.dom.minidom.parseString(xmlstring)
	remove_whilespace_nodes(doc.documentElement)
	return elementtodict(doc.documentElement)

def elementtodict(parent):
	child = parent.firstChild
	if (not child):
		return None
	elif (child.nodeType == xml.dom.minidom.Node.TEXT_NODE):
		return child.nodeValue

	d={}
	while child is not None:
		if (child.nodeType == xml.dom.minidom.Node.ELEMENT_NODE):
			try:
				d[child.tagName]
			except KeyError:
				d[child.tagName]=[]
			d[child.tagName].append(elementtodict(child))
		child = child.nextSibling
	return d

def remove_whilespace_nodes(node, unlink=True):
	remove_list = []
	for child in node.childNodes:
		if child.nodeType == xml.dom.Node.TEXT_NODE and not child.data.strip():
			remove_list.append(child)
		elif child.hasChildNodes():
			remove_whilespace_nodes(child, unlink)
	for node in remove_list:
		node.parentNode.removeChild(node)
		if unlink:
			node.unlink()

xmldict = xmltodict(html)
object_htmls = xmldict['body'][0]['div'][1]['div'][0]['div'][0]['div'][0]['div'][0]['div'][0]['div']

objects = []

for object_html in object_htmls:
	obj = {}
	obj['name'] = object_html['h3'][0].replace(' ', '')
	obj['description'] = object_html['p'][0]
	obj['variables'] = []
	for variable_row in object_html['table'][0]['tbody'][0]['tr']:
		variable = {}
		variable['name'] = variable_row['td'][0]
		variable['type'] = variable_row['td'][1]['tt'][0]['span'][0]
		variable['comment'] = variable_row['td'][2]
		obj['variables'].append(variable)
	objects.append(obj)

#pp = pprint.PrettyPrinter(indent=2)
#pp.pprint(objects)

def objc_variable_format(python_name):
	"""Removes underscores, capitalizes first letter afterwards"""
	if python_name == 'id':
		return 'identifier'
	if python_name == 'description':
		return 'descriptionText'
	while python_name.find('_') != -1:
		index = python_name.find('_')
		python_name = python_name[0:index] + python_name[index + 1].capitalize() + python_name[index + 2:]
	return python_name

def template_format_dict(obj):
	table = {}
	class_name = class_prefix + obj['name']
	table['name'] = class_name
	table['comment'] = obj['description'].replace("\n", "\n//  ")
	instance_vars = ''
	property_declarations = ''
	synthesize = ''
	element_to_property = ''
	releases = ''
	dynamic = ''
	for variable in obj['variables']:
		objc_type = ''
		if variable['type'] == 'string':
			objc_type = 'NSString *'
		elif variable['type'] == 'date':
			objc_type = 'NSDate *'
		else:
			objc_type = 'NSNumber *'
		objc_name = objc_variable_format(variable['name'])
		instance_vars += '  ' + objc_type + '_' + objc_name + ";\n"
		if (variable['comment']):
			property_declarations += '//! ' + variable['comment'].replace('\n', ' ') + '\n'
		property_declarations += '@property (retain, nonatomic) ' + objc_type + objc_name + ";\n"
		synthesize += '@synthesize ' + objc_name + '=_' + objc_name + ";\n"
		element_to_property += '          @"' + variable['name'] + '", @"' + objc_name + '",\n'
		releases += '  [_' + objc_name + ' release];\n'
		dynamic += '@dynamic ' + objc_name + ';\n'
	table['instance_vars'] = instance_vars
	table['property_declarations'] = property_declarations
	table['synthesize'] = synthesize
	table['element_to_property'] = element_to_property
	table['releases'] = releases
	table['dynamic'] = dynamic
	return table

for obj in objects:
	class_name = class_prefix + obj['name']
	table = template_format_dict(obj)
	f = codecs.open(export_dir + '_' + class_name + '.h', 'w', encoding='utf-8')
	f.write(private_managed_header_template % table)
	f.close
	f = codecs.open(export_dir + '_' + class_name + '.m', 'w', encoding='utf-8')
	f.write(private_managed_source_template % table)
	f.close
	f = codecs.open(export_dir + class_name + '.h', 'w', encoding='utf-8')
	f.write(header_template % table)
	f.close
	f = codecs.open(export_dir + class_name + '.m', 'w', encoding='utf-8')
	f.write(source_template % table)
	f.close
