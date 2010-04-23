/**
 * @author Kelv
 */

do_hide = false
function confirmed() {
	if(document.getElementById('modified')==null)
		return true; 
	else 
		if(document.getElementById('is_modified').value=='Y')
			return confirm('               *****Warning*****\n           You have made changes.\n\nPress OK to lose changes and continue.\n                             or\n                    Press CANCEL.'); 
		else 
			return true;
}

function postAction(form,controller,action,alreadyConfirmed){
	form.action="/"+controller+"/"+action;
	if(action.substr(0,4)=='save'||action.substr(0,11)=='preferences'||alreadyConfirmed||confirmed()) 
		form.submit();
}

function fireEvent(obj,evt){
	
	var fireOnThis = obj;
	if( document.createEvent ) {
	  var evObj = document.createEvent('MouseEvents');
	  evObj.initEvent( evt, true, false );
	  fireOnThis.dispatchEvent(evObj);
	} else if( document.createEventObject ) {
	  fireOnThis.fireEvent('on'+evt);
	}
}

function checkAll(button){
	for (var i=0;i<button.form.elements.length;i++)
		if (button.form.elements[i].type=='checkbox'&&!button.form.elements[i].disabled)
			button.form.elements[i].checked=(button.value=='Select All')
	if(button.value == 'Select All')
		button.value = 'Unselect All'
	else
		button.value = 'Select All'
}

function over(element) {
	document.getElementById(element+'Expanded').style.display='inline'
	document.getElementById(element).style.color= '#FF0101'
}

function out(element) {
	document.getElementById(element+'Expanded').style.display='none'
	document.getElementById(element).style.color= '#A7A9AC'
}

function show_type_descr(me,message) {
	document.getElementById('connectionTypeDescr').style.display = 'inline';
	document.getElementById('connectionTypeDescr').style.left = ''+(me.offsetLeft - 15)+'px';
	document.getElementById('connectionTypeDescr').style.top = ''+(me.offsetTop - 5)+'px';
	document.getElementById('connectionTypeDescr').innerHTML = message.replace(/%%/g,"\"");
}

function hide_type_descr(me) {
	document.getElementById('connectionTypeDescr').style.display = 'none';
	document.getElementById('connectionTypeDescr').innerHTML = '';
}

function show_message(div_id,me,message) {
	document.getElementById(div_id).style.display = 'inline';
	document.getElementById(div_id).style.left = ''+(me.offsetLeft - 15)+'px';
	document.getElementById(div_id).style.top = ''+(me.offsetTop - 5)+'px';
	document.getElementById(div_id).innerHTML = message.replace(/%%/g,"\"");
}

function hide_message(div_id,me) {
	document.getElementById(div_id).style.display = 'none';
	document.getElementById(div_id).innerHTML = '';
}

function show_info_div(me,divId,offsetX,offsetY) {
	document.getElementById(divId).style.display = 'inline';
	if(offsetX == -1) 
		document.getElementById(divId).style.left = '20px';
	else
		document.getElementById(divId).style.left = ''+(me.offsetLeft - offsetX)+'px';
	document.getElementById(divId).style.top = ''+(me.offsetTop - offsetY)+'px';
}

function hide_info_div(me,divId) {
	document.getElementById(divId).style.display = 'none';
}

function parentDiv(ref)
{
	ok=0; // it's just to start the loop, we don't use it to get out.
	while (!ok) {
		ref = ref.parentNode;
		if (ref.nodeType==1) //check that the node is a tag, not text (type=3)
			if (String(ref.nodeName)=="DIV")
				return ref;
	}
}

//New select tab function
function select_tab(tabNumber,maxTab) {
	current_tab_objs = document.getElementsByName('current_tab');
	for(var i=0; i<current_tab_objs.length; i++)
		current_tab_objs[i].value = tabNumber;
	for(var i=1; i<=maxTab; i++) {
		if(i==tabNumber) {
			if($('tab_'+i))
				$('tab_'+i).addClassName('selected');
			if($('tab_'+i+'_content'))
				$('tab_'+i+'_content').style.display = 'block';
			if ($('tab_' + i + '_on_focus'))
				$('tab_' + i + '_on_focus').click();
		}
		else {
			if($('tab_'+i))
				$('tab_'+i).removeClassName('selected');
			if($('tab_'+i+'_content'))
				$('tab_'+i+'_content').style.display = 'none';
		}
	}
};


function select_tab_old(tabNumber,maxTab) {
	for(var i=1; i<=maxTab; i++) {
		if (i == tabNumber) {
			if ($('inner_tab_' + i)) 
				$('inner_tab_' + i).style.background = 'url(/images/selected_tab.gif) no-repeat right top';
			if ($('tab_' + i)) 
				$('tab_' + i).style.background = 'url(/images/selected_tab_left.gif) no-repeat left top';
			if ($('tab_' + i + '_content')) 
				$('tab_' + i + '_content').style.display = 'block';
			if ($('tab_' + i + '_on_focus'))
				$('tab_' + i + '_on_focus').click();
		}
		else {
			if($('inner_tab_'+i))
				$('inner_tab_'+i).style.background = 'url(/images/deselected_tab.gif) no-repeat right top';
			if($('tab_'+i))
				$('tab_'+i).style.background = 'url(/images/deselected_tab_left.gif) no-repeat left top';
			if($('tab_'+i+'_content'))
				$('tab_'+i+'_content').style.display = 'none';
		}
	}
}

function rotate_tabs(maxRow) {
	var tab_1 = document.getElementById('tab_row_1').innerHTML
	for(var i=2; i<=maxRow; i++)
		document.getElementById('tab_row_'+(i-1)).innerHTML = document.getElementById('tab_row_'+i).innerHTML;
	document.getElementById('tab_row_'+maxRow).innerHTML = tab_1
	var current_row = document.getElementsByName('current_tab_row')[0].value;
	if(current_row == (''+maxRow))
		current_row = '1';
	else
		current_row++;
	current_tab_row_objs = document.getElementsByName('current_tab_row');
	for(var i=0; i<current_tab_row_objs.length; i++)
		current_tab_row_objs[i].value = current_row;
}

var tabs_set = false;

function select_tab_with_row(tabNumber,maxTab,tabRow,maxRow) {
	while(document.getElementsByName('current_tab_row')[0].value != tabRow)
		rotate_tabs(maxRow);
	current_tab_objs = document.getElementsByName('current_tab');
	for(var i=0; i<current_tab_objs.length; i++)
		current_tab_objs[i].value = tabNumber;
	for(var i=1; i<=maxTab; i++) {
		if(i==tabNumber) {
			if(document.getElementById('inner_tab_'+i))
				document.getElementById('inner_tab_'+i).style.background = 'url(/images/selected_tab.gif) no-repeat right top';
			if(document.getElementById('tab_'+i))
				document.getElementById('tab_'+i).style.background = 'url(/images/selected_tab_left.gif) no-repeat left top';
			if(document.getElementById('tab_'+i+'_content'))
				document.getElementById('tab_'+i+'_content').style.display = 'block';
		}
		else {
			if(document.getElementById('inner_tab_'+i))
				document.getElementById('inner_tab_'+i).style.background = 'url(/images/deselected_tab.gif) no-repeat right top';
			if(document.getElementById('tab_'+i))
				document.getElementById('tab_'+i).style.background = 'url(/images/deselected_tab_left.gif) no-repeat left top';
			if(document.getElementById('tab_'+i+'_content'))
				document.getElementById('tab_'+i+'_content').style.display = 'none';
		}
	}
}

function reset_tabs() {
	current_tab_row_objs = document.getElementsByName('current_tab_row');
	if(tabs_set||!current_tab_row_objs)
		return;
	for(var i=0; i<current_tab_row_objs.length; i++)
		current_tab_row_objs[i].value = 1;
	current_tab_objs = document.getElementsByName('current_tab');
	if(tabs_set||!current_tab_objs)
		return;
	for(var i=0; i<current_tab_objs.length; i++)
		current_tab_objs[i].value = 1;
	if (document.getElementById("do_select_tab")) {
		//alert("Reseting: "+document.getElementById("do_select_tab").value);
		eval(document.getElementById("do_select_tab").value);
	}
}

function set_all_modified(val,text) {
	mod_objs = document.getElementsByName('modified')
	for(var i=0; i<mod_objs.length; i++)
		mod_objs[i].innerHTML = "<input id='is_modified' type='hidden' value='"+val+"'/>"+text;
}

function getElementsByName_iefix(tag, name) {
     var elem = document.getElementsByTagName(tag);
     var arr = new Array();
     for(i = 0,iarr = 0; i < elem.length; i++) {
          att = elem[i].getAttribute("name");
          if(att == name) {
               arr[iarr] = elem[i];
               iarr++;
          }
     }
     return arr;
}

function toggle_read_only(read_only) {
	var read_only_objs, editable_objs, make_read_only_objs, make_editable_objs;
	if(navigator.appName.indexOf('Microsoft')<0) {
		read_only_objs = document.getElementsByName('read_only')
		editable_objs = document.getElementsByName('editable')
		make_read_only_objs = document.getElementsByName('make_read_only')
		make_editable_objs = document.getElementsByName('make_editable')
	} else {
		read_only_objs = getElementsByName_iefix('div','read_only')
		editable_objs = getElementsByName_iefix('div','editable')
		make_read_only_objs = getElementsByName_iefix('div','make_read_only')
		make_editable_objs = getElementsByName_iefix('div','make_editable')
	}
	for(var i=0; i<read_only_objs.length; i++)
		if(read_only)
			read_only_objs[i].style.display = 'inline';
		else
			read_only_objs[i].style.display = 'none';
	for(var i=0; i<editable_objs.length; i++)
		if(read_only)
			editable_objs[i].style.display = 'none';
		else
			editable_objs[i].style.display = 'inline';
	for(var i=0; i<make_editable_objs.length; i++)
		if(read_only)
			make_editable_objs[i].style.display = 'block';
		else
			make_editable_objs[i].style.display = 'none';
	for(var i=0; i<make_read_only_objs.length; i++)
		if(read_only)
			make_read_only_objs[i].style.display = 'none';
		else
			make_read_only_objs[i].style.display = 'block';
}

function toggle_edit_poi_service(on,off,id) {
	document.getElementById('edit_service_fields_'+on+'_'+id).style.display = 'block';
	document.getElementById('edit_service_fields_'+off+'_'+id).style.display = 'none';
	document.getElementById('edit_service_action_'+on+'_'+id).style.display = 'block';
	document.getElementById('edit_service_action_'+off+'_'+id).style.display = 'none';
}

function check_for_map() {
	var map_button = document.getElementById('map_button');
	if(map_button)
		map_button.click();
}

function resize_content() {
	return;
	var winH = 700;
	var winW = 1200;
	if (parseInt(navigator.appVersion) > 3) {
		if (navigator.appName == "Netscape") {
			winW = window.innerWidth - 16;
			winH = window.innerHeight - 16;
		}
		if (navigator&&navigator.appName&&navigator.appName.indexOf("Microsoft") != -1) {
			winW = document.body.offsetWidth - 20;
			winH = document.body.offsetHeight - 20;
		}
	}
	document.getElementById('website_content').style.width = ''+winW+'px';
	document.getElementById('website_content').style.height = ''+(winH-140)+'px';
	//alert("changed to "+document.getElementById('website_content').style.width+","+(document.getElementById('website_content').style.height));
}