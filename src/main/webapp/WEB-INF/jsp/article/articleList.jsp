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
						<td>名称:</td>
						<td><input type="text" name="name" class="easyui-validatebox"/></td>
						
						<td align="right">
							<a id="btn" href="#" onclick="searchFun();" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
							<a id="btn" href="#" onclick="clearFun();" class="easyui-linkbutton" data-options="iconCls:'icon-search'">清空</a>
						</td>
					</tr>
				</table>
			</form>
		</div>   
      	<div id="article_toolbar">
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
	    	
	    	 <div class="easyui-tabs" data-options="fit:true,plain:true">
                <div title="文章列表" style="padding:10px;">
                	<table id="articledg"></table>  
                </div>
                <div title="新增文章" data-options="
                					fit:true,
                					plain:true
					                href:'${pageContext.request.contextPath}/article/toAddArticlePage',
					                closable:true" 
					                style="padding:10px">
                </div>
               <div title="文章分类" data-options="
                					fit:true,
                					plain:true
					                href:'${pageContext.request.contextPath}/article/toAddArticlePage',
					                closable:true" 
					                style="padding:10px">
                </div>
                
            </div>
	    </div> 
		<script type="text/javascript">
			var articledg;
			$(function(){
				articledg = $('#articledg').datagrid({ 
					fitColumns:true,
					idField:'id', 
					rownumbers : true,
				    url:'${pageContext.request.contextPath}/article/findAllArticle',  
				    pagination : true,  
				    sortName : 'id',
					sortOrder : 'desc',
					checkOnSelect:false,
					selectOnCheck:false,
					pageSize : 10,
					pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500 ], 
				    columns:[[    
				        {field:'id',title:'id',width:100,checkbox:true},    
				        {field:'title',title:'标题',width:100},
				        {field:'url',title:'所属分类',width:200}, 
				        {field:'createdDate',title:'创建时间',width:100},
				        {field:'availableStr',title:'状态',width:100}
				    ]],
				    toolbar: '#article_toolbar',
				    onSelect:function(rowIndex,rowData){
				    	articledg.datagrid('unselectAll');
				    } 
				});
			});
			
			//查询方法
			function searchFun(){
				articledg.datagrid('load',base.serializeObject($('#searchForm')));
			}
			//清空查询表单
			function clearFun(){
				$('#searchForm input').val('');
				articledg.datagrid('load',{});
			}
			
			/**
			 * 新增函数
			 * @returns {} 
			 */
			var addarticleDialog;
			function insertFun(){
				addarticleDialog =$("<div/>").dialog({
									title: '新增',    
								    width: 1000,    
								    height:600,    
								    closed: false,    
								    cache: false,    
								    href: '${pageContext.request.contextPath}/article/toAddarticlePage',    
								    modal: true,
								    buttons : [ {
										text : '添加',
										handler : function() {
											$('#addarticleForm').form('submit', {   
												url: '${pageContext.request.contextPath}/article/addarticle',  
											    success: function(data){ 
											    	var json=$.parseJSON(data);  
											    	
											        if (json.status==0){
											        	//刷新数据列表,效率较低
											        	//$('#dg').datagrid('reload');
											        	//将新增的数据直接添加到数据列表中
											        	articledg.datagrid('insertRow',{index:0,row:json.array});
											        	//消息提示 
											            showMessage('提示',json.desc);
											           
											        }else{
											        	showMessage('错误',json.desc);
											        } 
											        //关闭弹出窗
										        	addarticleDialog.dialog('close');
										        	
											    }    
											}); 
										}
									}],
									onClose:function(){
										//在窗口关闭之后触发
										addarticleDialog.dialog('destroy');
									}  
							});
			}
			
			/**
			 * 编辑函数
			 * @returns {} 
			 */
			var editarticleDialog;
			function editFun(){
				//首先判断是否有勾选记录
				var rows = articledg.datagrid('getChecked');
				
				//获取编辑行的索引值，用于编辑成功后直接更新该行的数据
				var rowindex = articledg.datagrid('getRowIndex',rows[0]);
				if(rows.length==1){
					editarticleDialog =$("<div/>").dialog({
								title: '编辑',    
							    width: 1000,    
							    height:600,    
							    closed: false,    
							    cache: false,    
							    href: '${pageContext.request.contextPath}/article/toEditarticlePage',    
							    modal: true,
							    buttons : [ {
									text : '编辑',
									handler : function() {
										$('#editarticleForm').form('submit', {   
												url: '${pageContext.request.contextPath}/article/editarticle',  
											    success: function(data){ 
											    	var json=$.parseJSON(data); 
											    	
											        if (json.status==0){
											        	//刷新数据列表,效率较低
											        	//$('#dg').datagrid('reload');
											        	//将编辑的数据直接更新数据列表中对应的列
											        	articledg.datagrid('updateRow',{index:rowindex,row:json.array});
											        	//console.info(json.array);
											        	//消息提示 
											            showMessage('提示',json.desc);
											        }else{
											        	showMessage('提示',json.desc);
											        }  
											        //关闭弹出窗
										        	editarticleDialog.dialog('close');
											    }    
											}); 
									}
								} ],
								onLoad:function(){
									//加载编辑窗口的时候，给表单赋值
									$.post('${pageContext.request.contextPath}/article/findarticleById',{id:rows[0].id},function(data){
										var json=$.parseJSON(data); 
										if(json.status==0){
											$('#editarticleForm').form('load',json.array);
											$('#logo').attr('src','${pageContext.request.contextPath}/article/findImgById?id='+rows[0].id);
											
										}
									});
								},
								onClose:function(){
									//在窗口关闭之后触发
									editarticleDialog.dialog('destroy');
								}
								  
					});
				}else if(rows.length>1){
					$.messager.alert('提示','同一时间只能编辑一条记录！','error');
				}else{
					$.messager.alert('提示','请选择要编辑的记录！','error');
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