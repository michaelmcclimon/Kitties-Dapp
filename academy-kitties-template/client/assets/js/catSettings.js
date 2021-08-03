
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
