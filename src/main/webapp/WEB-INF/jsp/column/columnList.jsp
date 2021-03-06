<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/jsp/taglib.jsp" %>
</head>

<body  class="easyui-layout">   
	  
		<div data-options="region:'north',title:'查询条件',split:false" style="height:50px;padding:10px;">
			<form id="searchForm">
				<table style="font-size:12px;">
					<tr>
						<td>一级栏目:</td>
						<td><input type="text" name="name" class="easyui-validatebox"/></td>
						
						<td align="right">
							<a id="btn" href="#" onclick="searchFun();" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
							<a id="btn" href="#" onclick="clearFun();" class="easyui-linkbutton" data-options="iconCls:'icon-search'">清空</a>
						</td>
					</tr>
				</table>
			</form>
		</div>   
      	<div id="column_toolbar">
      		<table>
      			<tr>
    				<td>
      					<a id="btn" href="#" onclick="insertFun();" class="easyui-linkbutton" data-options="iconCls:'icon-add'">新增</a>
      				</td>
      				<td>
      				<div class="datagrid-btn-separator"></div>
      				</td>
    						<td>
      					<a id="btn" href="#" onclick="editFun();" class="easyui-linkbutton" data-options="iconCls:'icon-edit'">编辑</a>
      				</td>
      				<td>
      				<div class="datagrid-btn-separator"></div>
      				</td>
     					<td>
      					<a id="btn" href="#" onclick="deleteFun();" class="easyui-linkbutton" data-options="iconCls:'icon-remove'">删除</a>
      				</td>
      			</tr>
      		</table>
      	</div>
	    <div data-options="region:'center',title:'center title'" style="padding:5px;background:#eee;">
	    	<table id="columndg"></table>  
	    </div> 
		<script type="text/javascript">
			var columndg;
			$(function(){
				columndg = $('#columndg').treegrid({ 
					fitColumns:true,
					idField:'id',
					treeField:'name',
				    url:'${pageContext.request.contextPath}/column/findAllColumn',  
				    rownumbers: true,  
				    lines: true,
				    sortName : 'id',
					sortOrder : 'desc',
					checkOnSelect:false,
					selectOnCheck:false,
				    columns:[[    
				        {field:'id',title:'id',width:100,checkbox:true},    
				        {field:'parentId',title:'parentId',width:100,hidden:true},    
				        {field:'name',title:'名称',width:100},
				        {field:'url',title:'网址',width:200}, 
				        {field:'availableStr',title:'状态',width:100}
				    ]],
				    toolbar: '#column_toolbar',
				    onSelect:function(rowIndex,rowData){
				    	columndg.treegrid('unselectAll');
				    } 
				});
			});
			
			//查询方法
			function searchFun(){
				columndg.treegrid('load',base.serializeObject($('#searchForm')));
			}
			//清空查询表单
			function clearFun(){
				$('#searchForm input').val('');
				columndg.treegrid('load',{});
			}
			
			/**
			 * 新增函数
			 * @returns {} 
			 */
			var addcolumnDialog;
			function insertFun(){
				addcolumnDialog =$("<div/>").dialog({
									title: '新增',    
								    width: 1000,    
								    height:600,    
								    closed: false,    
								    cache: false,    
								    href: '${pageContext.request.contextPath}/column/toAddColumnPage',    
								    modal: true,
								    buttons : [ {
										text : '添加',
										handler : function() {
											$('#addColumnForm').form('submit', {   
												url: '${pageContext.request.contextPath}/column/addColumn',  
											    success: function(data){ 
											    	var json=$.parseJSON(data);  
											    	
											        if (json.status==0){
											        	//刷新数据列表,效率较低
											        	columndg.treegrid('reload');
											        	//将新增的数据直接添加到数据列表中
											        	//columndg.treegrid('insertRow',{index:0,row:json.array});
											        	//消息提示 
											            showMessage('提示',json.desc);
											           
											        }else{
											        	showMessage('错误',json.desc);
											        } 
											        //关闭弹出窗
										        	addcolumnDialog.dialog('close');
										        	
											    }    
											}); 
										}
									}],
									onClose:function(){
										//在窗口关闭之后触发
										addcolumnDialog.dialog('destroy');
									}  
							});
			}
			
			/**
			 * 编辑函数
			 * @returns {} 
			 */
			var editcolumnDialog;
			function editFun(){
				//首先判断是否有勾选记录
				var rows = columndg.datagrid('getChecked');
				
				//获取编辑行的索引值，用于编辑成功后直接更新该行的数据
				var rowindex = columndg.datagrid('getRowIndex',rows[0]);
				if(rows.length==1){
					editcolumnDialog =$("<div/>").dialog({
								title: '编辑',    
							    width: 1000,    
							    height:600,    
							    closed: false,    
							    cache: false,    
							    href: '${pageContext.request.contextPath}/column/toEditColumnPage',    
							    modal: true,
							    buttons : [ {
									text : '编辑',
									handler : function() {
										$('#editColumnForm').form('submit', {   
												url: '${pageContext.request.contextPath}/column/editColumn',  
											    success: function(data){ 
											    	var json=$.parseJSON(data); 
											    	
											        if (json.status==0){
											        	//刷新数据列表,效率较低
											        	columndg.treegrid('reload');
											        	//将编辑的数据直接更新数据列表中对应的列
											        	//columndg.datagrid('updateRow',{index:rowindex,row:json.array});
											        	//console.info(json.array);
											        	//消息提示 
											            showMessage('提示',json.desc);
											        }else{
											        	showMessage('提示',json.desc);
											        }  
											        //关闭弹出窗
										        	editcolumnDialog.dialog('close');
											    }    
											}); 
									}
								} ],
								onLoad:function(){
									//加载编辑窗口的时候，给表单赋值
									$.post('${pageContext.request.contextPath}/column/findColumnById',{id:rows[0].id},function(data){
										var json=$.parseJSON(data); 
										if(json.status==0){
											$('#editColumnForm').form('load',json.array);
										}
									});
								},
								onClose:function(){
									//在窗口关闭之后触发
									editcolumnDialog.dialog('destroy');
								}
								  
					});
				}else if(rows.length>1){
					$.messager.alert('提示','同一时间只能编辑一条记录！','error');
				}else{
					$.messager.alert('提示','请选择要编辑的记录！','error');
				}
			}
			
			function deleteFun(){
				var rows = columndg.treegrid('getChecked');
				var ids = [];
				if (rows.length > 0) {
					$.messager.confirm('请确认', '确定要删除勾选记录以及它的子级元素吗？', function(r) {
						if (r) {
							for ( var i = 0; i < rows.length; i++) {
								if(rows[i]._parentId != 0){  //强制性不能删除根目录
									ids.push(rows[i].id);
								}
							}
							$.ajax({
								url : '${pageContext.request.contextPath}/column/deleteColumn',  
								data : {
									ids : ids.join(',')
								},
								dataType : 'json',
								success : function(data) {
									 
									columndg.treegrid('load');
									columndg.treegrid('unselectAll');
									 if(data.status==0){
									  	showMessage( '提示',data.desc+'删除'+data.array+'条');
									 }else{
									 	showMessage( '提示',data.desc);
									 }
									
								}
							});
						}
					});
				} else {
					$.messager.alert('提示', '请勾选要删除的记录！', 'error');
				}
			}
			/**
			 * 提示消息
			 * @param {} title
			 * @param {} msg
			 * @returns {} 
			 */
			function showMessage(title,msg){
				$.messager.show({
					title:title,
					msg:msg,
					showType:'slide',
					timeout:5000
				});
			}
		</script>
</body> 

</html>