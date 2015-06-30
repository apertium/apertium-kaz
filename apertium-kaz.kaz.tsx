<?xml version="1.0" encoding="UTF-8"?>
<tagger name="catalan">
<tagset>
  <def-label name="NOM">
    <tags-item tags="n"/>
    <tags-item tags="n.*"/>
    <tags-item tags="adj.subst.*"/>
    <tags-item tags="adj.comp.subst.*"/>
  </def-label> 
  <def-label name="LQUOT">
    <tags-item tags="lquot"/>
  </def-label> 
  <def-label name="RQUOT">
    <tags-item tags="rquot"/>
  </def-label> 
  <def-label name="ADV">
    <tags-item tags="adv"/>
    <tags-item tags="adv.comp"/>
    <tags-item tags="adj.advl"/>
    <tags-item tags="adj.comp.advl"/>
  </def-label> 
  <def-label name="ADJ">
    <tags-item tags="n.attr"/>
    <tags-item tags="adv.attr"/>
    <tags-item tags="adj"/>
    <tags-item tags="adj.comp"/>
  </def-label>
  <def-label name="CNJSUBS" closed="true">
    <tags-item tags="cnjsub"/>
  </def-label>
  <def-label name="CNJCOORD" closed="true">
    <tags-item tags="cnjcoo"/>
  </def-label>
  <def-label name="CNJADV">
    <tags-item tags="cnjadv"/>
  </def-label>
  <def-label name="DET" closed="true">
    <tags-item tags="det.dem"/>
    <tags-item tags="det.ref"/>
    <tags-item tags="det.ind"/>
    <tags-item tags="det.def"/>
    <tags-item tags="det.pos"/>
    <tags-item tags="det.itg"/> 
  </def-label>
<def-label name="DETQNT_ORD" closed="true"><!--Poden anar precedits dels altres tipus de determinant -->
    <tags-item tags="det.qnt"/>
    <tags-item tags="det.ord"/>
  </def-label> 

  <def-label name="NUM" closed="true">
    <tags-item tags="num.*"/>
    <tags-item tags="num"/>
  </def-label>
  <def-label name="ADVITG" closed="true">
    <tags-item tags="adv.itg"/>
  </def-label>
  <def-label name="SYM" closed="true">
    <tags-item tags="sym"/>
  </def-label>
  <def-label name="INTERJ">
    <tags-item tags="ij"/>
  </def-label>
  <def-label name="ANTROPONIM">
    <tags-item tags="np.ant.*"/>
    <tags-item tags="np.cog.*"/>
  </def-label>
  <def-label name="TOPONIM">
    <tags-item tags="np.top.*"/>
  </def-label>
  <def-label name="NPALTRES">
    <tags-item tags="np.al.*"/>
    <tags-item tags="np.org.*"/>
  </def-label>
  <def-label name="PREDET" closed="true">
    <tags-item tags="predet.*"/>
  </def-label>
  <def-label name="MOD" closed="true">
    <tags-item tags="mod_ass"/>
    <tags-item tags="mod"/>
  </def-label>
  <def-label name="EMPH" closed="true">
    <tags-item tags="emph"/>
  </def-label>
  <def-label name="POSTADV" closed="true">
    <tags-item tags="postadv"/>
  </def-label>
  <def-label name="POST" closed="true">
    <tags-item tags="post"/>
  </def-label>
  <def-label name="PRNALTRES" closed="true">
    <tags-item tags="prn.*"/>
  </def-label>
  <def-label name="VAUX" closed="true">
    <tags-item tags="vaux.*"/>
  </def-label>
  <def-label name="VLEX">
    <tags-item tags="v.*"/>
  </def-label>
 <def-label name="GUIO" closed="true">
    <tags-item tags="guio"/>
  </def-label> 
  <def-label name="COP" closed="true">
    <tags-item tags="cop.*"/>
  </def-label> 
  <def-label name="APOS" closed="true">
    <tags-item tags="apos"/>
  </def-label> 
  <def-label name="QST" closed="true">
    <tags-item tags="qst"/>
  </def-label> 
<def-mult>
<def-mult name="VLEXCOP">  
    <sequence>
      <label-item label="VLEX"/>
      <label-item label="COP"/>
    </sequence>
</def-mult>
<def-mult name="ADJCOP">  
    <sequence>
      <label-item label="ADJ"/>
      <label-item label="COP"/>
    </sequence>
</def-mult>
<def-mult name="NOMCOP">  
    <sequence>
      <label-item label="NOM"/>
      <label-item label="COP"/>
    </sequence>
</def-mult>

<def-mult name="ADVCOP">  
    <sequence>
      <label-item label="ADV"/>
      <label-item label="COP"/>
    </sequence>
</def-mult>
<def-mult name="VAUXCOP">  
    <sequence>
      <label-item label="VAUX"/>
      <label-item label="COP"/>
    </sequence>
</def-mult>
<def-mult name="PRNALTRESCOP">  
    <sequence>
      <label-item label="PRNALTRES"/>
      <label-item label="COP"/>
    </sequence>
</def-mult>
<def-mult name="NPALTRESCOP">  
    <sequence>
      <label-item label="NPALTRES"/>
      <label-item label="COP"/>
    </sequence>
</def-mult>
<def-mult name="VLEXQST">  
    <sequence>
      <label-item label="VLEX"/>
      <label-item label="QST"/>
    </sequence>
</def-mult>
<def-mult name="VAUXQST">  
    <sequence>
      <label-item label="VAUX"/>
      <label-item label="QST"/>
    </sequence>
</def-mult>

<def-mult name="VLEXPOSTADV">  
    <sequence>
      <label-item label="VLEX"/>
      <label-item label="POSTADV"/>
    </sequence>
</def-mult>
<def-mult name="ADJPOSTADV">  
    <sequence>
      <label-item label="ADJ"/>
      <label-item label="POSTADV"/>
    </sequence>
</def-mult>
<def-mult name="NOMPOSTADV">  
    <sequence>
      <label-item label="NOM"/>
      <label-item label="POSTADV"/>
    </sequence>
</def-mult>

<def-mult name="ADVPOSTADV">  
    <sequence>
      <label-item label="ADV"/>
      <label-item label="POSTADV"/>
    </sequence>
</def-mult>
<def-mult name="VAUXPOSTADV">  
    <sequence>
      <label-item label="VAUX"/>
      <label-item label="POSTADV"/>
    </sequence>
</def-mult>
<def-mult name="PRNALTRESPOSTADV">  
    <sequence>
      <label-item label="PRNALTRES"/>
      <label-item label="POSTADV"/>
    </sequence>
</def-mult>
<def-mult name="NUMPOSTADV">  
    <sequence>
      <label-item label="NUM"/>
      <label-item label="POSTADV"/>
    </sequence>
</def-mult>
<def-mult name="NPALTRESPOSTADV">  
    <sequence>
      <label-item label="NPALTRES"/>
      <label-item label="POSTADV"/>
    </sequence>
</def-mult>

<def-mult name="VLEXCNJCOO">  
    <sequence>
      <label-item label="VLEX"/>
      <label-item label="CNJCOO"/>
    </sequence>
</def-mult>
<def-mult name="ADJCNJCOO">  
    <sequence>
      <label-item label="ADJ"/>
      <label-item label="CNJCOO"/>
    </sequence>
</def-mult>
<def-mult name="NOMCNJCOO">  
    <sequence>
      <label-item label="NOM"/>
      <label-item label="CNJCOO"/>
    </sequence>
</def-mult>

<def-mult name="ADVCNJCOO">  
    <sequence>
      <label-item label="ADV"/>
      <label-item label="CNJCOO"/>
    </sequence>
</def-mult>
<def-mult name="VAUXCNJCOO">  
    <sequence>
      <label-item label="VAUX"/>
      <label-item label="CNJCOO"/>
    </sequence>
</def-mult>
<def-mult name="PRNALTRESCNJCOO">  
    <sequence>
      <label-item label="PRNALTRES"/>
      <label-item label="CNJCOO"/>
    </sequence>
</def-mult>
<def-mult name="NPALTRESCNJCOO">  
    <sequence>
      <label-item label="NPALTRES"/>
      <label-item label="CNJCOO"/>
    </sequence>
</def-mult>

<def-mult name="VLEXEMPH">  
    <sequence>
      <label-item label="VLEX"/>
      <label-item label="EMPH"/>
    </sequence>
</def-mult>
<def-mult name="NPALTRESCOPMOD">  
    <sequence>
      <label-item label="NPALTRES"/>
      <label-item label="COP"/>
      <label-item label="MOD"/>
    </sequence>
</def-mult>
<def-mult name="ADJCOPMOD">  
    <sequence>
      <label-item label="ADJ"/>
      <label-item label="COP"/>
      <label-item label="MOD"/>
    </sequence>
</def-mult>

<def-mult name="ADJCOPQST">  
    <sequence>
      <label-item label="ADJ"/>
      <label-item label="COP"/>
      <label-item label="QST"/>
    </sequence>
</def-mult>
<def-mult name="NOMPOST">  
    <sequence>
      <label-item label="NOM"/>
      <label-item label="POST"/>
    </sequence>
</def-mult>

</def-mult>
</tagset>
<forbid>
    <label-sequence>
      <label-item label="COP"/>
      <label-item label="COP"/>
    </label-sequence>
    <label-sequence>
      <label-item label="COP"/>
      <label-item label="POST"/>
    </label-sequence>


</forbid>

 
</tagger>
