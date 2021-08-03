
var colors = Object.values(allColors())

var defaultDNA = {
    "headcolor" : 10,
    "mouthcolor" : 10,
    "eyescolor" : 10,
    "earscolor" : 10,
    //Cattributes
    "eyesShape" : 1,
    "decorationPattern" : 1,
    "decorationMidcolor" : 10,
    "decorationSidescolor" : 10,
    "animation" :  1,
    "lastNum" :  1
    }

// when page load
$( document ).ready(function() {
  $('#dnabody').html(defaultDNA.headColor);
  $('#dnamouth').html(defaultDNA.mouthColor);
  $('#dnaeyes').html(defaultDNA.eyesColor);
  $('#dnaears').html(defaultDNA.earsColor);
    
   $('#dnashape').html(defaultDNA.eyesShape)
   $('#dnadecoration').html(defaultDNA.decorationPattern)
   $('#dnadecorationMid').html(defaultDNA.decorationMidcolor)
   $('#dnadecorationSides').html(defaultDNA.decorationSidescolor)
   $('#dnaanimation').html(defaultDNA.animation)
   $('#dnaspecial').html(defaultDNA.lastNum)

  renderCat(defaultDNA)
});

function getDna(){
    var dna = ''
    dna += $('#dnabody').html()
    dna += $('#dnamouth').html()
    dna += $('#dnaeyes').html()
    dna += $('#dnaears').html()
    dna += $('#dnashape').html()
    dna += $('#dnadecoration').html()
    dna += $('#dnadecorationMid').html()
    dna += $('#dnadecorationSides').html()
    dna += $('#dnaanimation').html()
    dna += $('#dnaspecial').html()

    return parseInt(dna)
}

function renderCat(dna){
    headColor(colors[dna.headcolor],dna.headcolor)
    $('#bodycolor').val(dna.headcolor)
    eyesColor(colors[dna.eyescolor],dna.eyescolor)
    $('#eyescolor').val(dna.eyescolor)
    earsColor(colors[dna.earscolor],dna.earscolor)
    $('#earscolor').val(dna.earscolor)
    mouthColor(colors[dna.mouthcolor],dna.mouthcolor)
    $('#mouthcolor').val(dna.mouthcolor)
    eyeVariation(dna.eyesShape)
    $('#eyeshape').val(dna.eyesShape)
    decorationVariation(dna.decorationPattern)
    $('#decorationpattern').val(dna.decorationPattern)
    decorationMidColor(colors[dna.decorationMidcolor],dna.decorationMidcolor)
    $('#decorationmid').val(dna.decorationMidcolor)
    decorationSidesColor(colors[dna.decorationSidescolor],dna.decorationSidescolor)
    $('#decorationsides').val(dna.decorationSidescolor)
    animationsPlayer(dna.animation)
    $('#animation').val(dna.animation)

  
}

// Changing cat colors
$('#bodycolor').change(()=>{
    var colorVal = $('#bodycolor').val()
    headColor(colors[colorVal],colorVal)
})
$('#eyescolor').change(()=>{
  var colorVal = $('#eyescolor').val()
  eyesColor(colors[colorVal],colorVal)
})
$('#earscolor').change(()=>{
  var colorVal = $('#earscolor').val()
  earsColor(colors[colorVal],colorVal)
})
$('#mouthcolor').change(()=>{
  var colorVal = $('#mouthcolor').val()
  mouthColor(colors[colorVal],colorVal)
})
$('#eyeshape').change(()=>{
  var shape = parseInt($('#eyeshape').val())
  eyeVariation(shape)
})

$('#decorationpattern').change(()=>{
  var pattern = parseInt($('#decorationpattern').val())
  decorationVariation(pattern)
})

$('#decorationmid').change(()=>{
  var colorVal = $('#decorationmid').val()
  decorationMidColor(colors[colorVal],colorVal)
})

$('#decorationsides').change(()=>{
  var colorVal = $('#decorationsides').val()
  decorationSidesColor(colors[colorVal],colorVal)
})
$('#animation').change(()=>{
  var anim = parseInt($('#animation').val())
  console.log(anim)
  animationsPlayer(anim)
})

$('#btnColorsTab').click(()=>{
  $("#headGroup").show()
  $("#mouthGroup").show()
  $("#eyesGroup").show()
  $("#earsGroup").show()

  $("#eyeShapeGroup").hide();
  $("#decoGroup").hide();
  $('#midDecoGroup').hide();
  $('#sideDecoGroup').hide();
  $("#animGroup").hide();
})


$('#btnAttributesTab').click(()=>{
  $('#headGroup').hide();
  $('#mouthGroup').hide();
  $('#eyesGroup').hide();
  $('#earsGroup').hide();

  $('#eyeShapeGroup').show();
  $('#decoGroup').show();
  $('#midDecoGroup').show();
  $('#sideDecoGroup').show();
  $("#animGroup").show();
})

//Randomize Function
$('#random').click(()=>{
  var bodycolor = Math.floor(Math.random() * 89) + 10;
  headColor(colors[bodycolor],bodycolor)
  $("#bodycolor").val(bodycolor)
  var mouthcolor = Math.floor(Math.random() * 89) + 10;
  mouthColor(colors[mouthcolor],mouthcolor)
  $("#mouthcolor").val(mouthcolor)
  var eyescolor = Math.floor(Math.random() * 89) + 10;
  eyesColor(colors[eyescolor],eyescolor)
  $("#eyescolor").val(eyescolor)
  var earscolor = Math.floor(Math.random() * 89) + 10;
  earsColor(colors[earscolor],earscolor)
  $("#earscolor").val(earscolor)
  var eyevar = Math.floor(Math.random() * (7 - 1 + 1) + 1);
  eyeVariation(eyevar)
  $("#eyeshape").val(eyevar)
  var decovar = Math.floor(Math.random() * (7 - 1 + 1) + 1);
  decorationVariation(decovar)
  $("#decorationpattern").val(decovar)
  var decMidVar = Math.floor(Math.random() * 89) + 10;
  decorationMidColor(colors[decMidVar],decMidVar)
  $("#decorationmid").val(decMidVar)
  var decSideVar = Math.floor(Math.random() * 89) + 10;
  decorationSidesColor(colors[decSideVar],decSideVar)
  $("#decorationsides").val(decSideVar)
  var anim = Math.floor(Math.random() * (7 - 1 + 1) + 1);
  animationsPlayer(anim)
  $("#animation").val(anim)
})

$('#reset').click(()=>{

  headColor(colors[defaultDNA.headColor],defaultDNA.headColor)
  $("#bodycolor").val(defaultDNA.headColor)
 
  mouthColor(colors[defaultDNA.mouthColor],defaultDNA.mouthColor)
  $("#mouthcolor").val(defaultDNA.mouthColor)
 
  eyesColor(colors[defaultDNA.eyesColor],defaultDNA.eyesColor)
  $("#eyescolor").val(defaultDNA.eyesColor)
  
  earsColor(colors[defaultDNA.earsColor],defaultDNA.earsColor)
  $("#earscolor").val(defaultDNA.earsColor)

  eyeVariation(defaultDNA.eyesShape)
  $("#eyeshape").val(defaultDNA.eyesShape)
  
  decorationVariation(defaultDNA.decorationPattern)
  $("#decorationpattern").val(defaultDNA.decorationPattern)

  decorationMidColor(colors[defaultDNA.decorationMidcolor],defaultDNA.decorationMidcolor)
  $("#decorationmid").val(defaultDNA.decorationMidcolor)
  
  decorationSidesColor(colors[defaultDNA.decorationSidescolor],defaultDNA.decorationSidescolor)
  $("#decorationsides").val(defaultDNA.decorationSidescolor)

  animationsPlayer(defaultDNA.animation)
  $("#animation").val(defaultDNA.animation)

  
})
