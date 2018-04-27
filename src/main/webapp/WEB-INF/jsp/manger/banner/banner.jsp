<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	pageContext.setAttribute("PATH", request.getContextPath());
%>
<html>
<head>
<meta charset="utf-8">
<meta name="renderer" content="webkit|ie-comp|ie-stand">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
<meta http-equiv="Cache-Control" content="no-siteapp" />
<link rel="stylesheet" type="text/css" href="${PATH }/manager/static/h-ui/css/H-ui.min.css" />
<link rel="stylesheet" type="text/css" href="${PATH }/manager/static/h-ui.admin/css/H-ui.admin.css" />
<link rel="stylesheet" type="text/css" href="${PATH }/manager/lib/Hui-iconfont/1.0.8/iconfont.css" />
<link rel="stylesheet" type="text/css" href="${PATH }/manager/static/h-ui.admin/skin/default/skin.css" id="skin" />
<link rel="stylesheet" type="text/css" href="${PATH }/manager/static/h-ui.admin/css/style.css" />
<title>banner图片列表</title>
</head>
<body>
	<nav class="breadcrumb">
		<i class="Hui-iconfont">&#xe67f;</i> 首页 
			<span class="c-gray en">&gt;</span> 图片管理 
			<span class="c-gray en">&gt;</span> banner图列表 
			<a class="btn btn-success radius r" style="line-height:1.6em;margin-top:3px" href="javascript:location.replace(location.href);" title="刷新" >
				<i class="Hui-iconfont">&#xe68f;</i>
			</a>
	</nav>
	<div class="page-container">
		<div class="cl pd-5 bg-1 bk-gray mt-20"> 
			<span class="l">
				<a class="btn btn-primary radius" onclick="picture_add('添加图片','${PATH }/bannerToAdd.do')" href="javascript:;">
					<i class="Hui-iconfont">&#xe600;</i> 添加图片
				</a>
			</span> 
		</div>
		<div class="mt-20">
			<table class="table table-border table-bordered table-bg table-hover table-sort" id="banner_table">
				<thead>
					<tr class="text-c">
						<th width="40"><input name="" type="checkbox" value=""></th>
						<th width="80">ID</th>
						<th>图片标题</th>
						<th width="100">封面</th>
						<th width="150">终端类型</th>
						<th width="60">图片顺序 </th>
						<th width="150">更新时间</th>
						<th width="60">发布状态</th>
						<th width="100">操作</th>
					</tr>
				</thead>
				<tbody>
					<!-- <tr class="text-c">
						<td class="td-manage"><a style="text-decoration:none" onClick="picture_stop(this,'10001')" href="javascript:;" title="下架"><i class="Hui-iconfont">&#xe6de;</i></a> <a style="text-decoration:none" class="ml-5" onClick="picture_edit('图库编辑','picture-add.html','10001')" href="javascript:;" title="编辑"><i class="Hui-iconfont">&#xe6df;</i></a> <a style="text-decoration:none" class="ml-5" onClick="picture_del(this,'10001')" href="javascript:;" title="删除"><i class="Hui-iconfont">&#xe6e2;</i></a></td>
					</tr> -->
				</tbody>
			</table>
		</div>
		<!-- 显示分页信息 -->
		<div class="row">
			<!--分页文字信息  -->
			<div class="col-md-6" id="page_info_area"></div>
			<!-- 分页条信息 -->
			<div class="col-md-6" id="page_nav_area">
			</div>
		</div>
	</div>
	<div>
		<br><br><br>
	</div>

<!--_footer 作为公共模版分离出去-->
<script type="text/javascript" src="${PATH }/manager/lib/jquery/1.9.1/jquery.min.js"></script> 
<script type="text/javascript" src="${PATH }/manager/lib/layer/2.4/layer.js"></script>
<script type="text/javascript" src="${PATH }/manager/static/h-ui/js/H-ui.min.js"></script> 
<script type="text/javascript" src="${PATH }/manager/static/h-ui.admin/js/H-ui.admin.js"></script> <!--/_footer 作为公共模版分离出去-->

<!--请在下方写此页面业务相关的脚本-->
<script type="text/javascript" src="${PATH }/manager/lib/My97DatePicker/4.8/WdatePicker.js"></script> 
<script type="text/javascript" src="${PATH }/manager/lib/datatables/1.10.0/jquery.dataTables.min.js"></script> 
<script type="text/javascript" src="${PATH }/manager/lib/laypage/1.2/laypage.js"></script>
<script type="text/javascript" src="${PATH }/common/js/pageinfo.js"></script>

<script type="text/javascript">



	$(function(){
		//去首页
		to_page(1);
	});
	
	function to_page(pageNum){
			$.ajax({
				url:"${PATH }/queryBannerList.do",
				data:"pageNum="+pageNum,
				type:"GET",
				success:function(result){
					//1、解析并显示员工数据
					build_emps_table(result);
					//2、解析并显示分页信息
					build_page_info(result);
					//3、解析显示分页条数据
					build_page_nav(result);
				}
			});
		}
	
	function build_emps_table(result){
			//清空table表格
			$("#banner_table tbody").empty();
			var users = result.extend.pageInfo.list;
			$.each(users,function(index,item){
				var checkBoxTd = $("<td><input type='checkbox' value='1' name=''></td>");
				var id = $("<td></td>").append(item.id);
				var bannertitle = $("<td></td>").append(item.bannertitle);
				var bannerimg = $("<td></td>").append("<img width='210' class='picture-thumb' src='"+"${PATH }/"+item.bannerimg+"'>");
				var terminal_type = $("<td></td>").append(item.terminalType == '0'?"PC":"APP");
				var bannerno = $("<td></td>").append(item.bannerno);
				var createTime = $("<td></td>").append(format(item.createTime));
				var is_use = $("<td class='td-status'></td>").append(item.is_use=='0'?
					$("<span class='label label-success radius'></span>").append("已发布"):
					$("<span class='label radius'></span>").append("已下架"));
				var btn = $("<td class='td-manage'></td>").append("<a style='text-decoration:none' onClick="+(item.is_use=='0'?"picture_stop(this,"+item.id+")":"admin_start(this,"+item.id+")")+" href='javascript:;' title="+(item.is_use=='0'?'下架':'发布')+">"
							+"<i class='Hui-iconfont'>"+(item.is_use == '0'?"&#xe631;":"&#xe615;")+"</i></a>"
							+"<a title='编辑' href='javascript:;' onclick='picture_edit('管理员编辑','picture-add.html',"+item.id+",'800','500')' class='ml-5' style='text-decoration:none'>"
							+"<i class='Hui-iconfont'>&#xe6df;</i></a> "
							+"<a title='删除' href='javascript:;' onclick='picture_del(this,"+item.id+")' class='ml-5' style='text-decoration:none'>"
							+"<i class='Hui-iconfont'>&#xe6e2;</i></a>");
							
				//append方法执行完成以后还是返回原来的元素
				$("<tr></tr>").append(checkBoxTd)
					.append(id)
					.append(bannertitle)
					.append(bannerimg)
					.append(terminal_type)
					.append(bannerno)
					.append(createTime)
					.append(is_use)
					.append(btn)
					.appendTo("#banner_table tbody");
			});
		}
	


/*图片-添加*/
function picture_add(title,url){
	var index = layer.open({
		type: 2,
		title: title,
		content: url
	});
	layer.full(index);
}

/*图片-查看*/
function picture_show(title,url,id){
	var index = layer.open({
		type: 2,
		title: title,
		content: url
	});
	layer.full(index);
}

/*图片-审核*/
function picture_shenhe(obj,id){
	layer.confirm('审核文章？', {
		btn: ['通过','不通过'], 
		shade: false
	},
	function(){
		$(obj).parents("tr").find(".td-manage").prepend('<a class="c-primary" onClick="picture_start(this,id)" href="javascript:;" title="申请上线">申请上线</a>');
		$(obj).parents("tr").find(".td-status").html('<span class="label label-success radius">已发布</span>');
		$(obj).remove();
		layer.msg('已发布', {icon:6,time:1000});
	},
	function(){
		$(obj).parents("tr").find(".td-manage").prepend('<a class="c-primary" onClick="picture_shenqing(this,id)" href="javascript:;" title="申请上线">申请上线</a>');
		$(obj).parents("tr").find(".td-status").html('<span class="label label-danger radius">未通过</span>');
		$(obj).remove();
    	layer.msg('未通过', {icon:5,time:1000});
	});	
}

/*图片-下架*/
function picture_stop(obj,id){
	layer.confirm('确认要下架吗？',function(index){
		$(obj).parents("tr").find(".td-manage").prepend('<a style="text-decoration:none" onClick="picture_start(this,id)" href="javascript:;" title="发布"><i class="Hui-iconfont">&#xe603;</i></a>');
		$(obj).parents("tr").find(".td-status").html('<span class="label label-defaunt radius">已下架</span>');
		$(obj).remove();
		layer.msg('已下架!',{icon: 5,time:1000});
	});
}

/*图片-发布*/
function picture_start(obj,id){
	layer.confirm('确认要发布吗？',function(index){
		$(obj).parents("tr").find(".td-manage").prepend('<a style="text-decoration:none" onClick="picture_stop(this,id)" href="javascript:;" title="下架"><i class="Hui-iconfont">&#xe6de;</i></a>');
		$(obj).parents("tr").find(".td-status").html('<span class="label label-success radius">已发布</span>');
		$(obj).remove();
		layer.msg('已发布!',{icon: 6,time:1000});
	});
}

/*图片-申请上线*/
function picture_shenqing(obj,id){
	$(obj).parents("tr").find(".td-status").html('<span class="label label-default radius">待审核</span>');
	$(obj).parents("tr").find(".td-manage").html("");
	layer.msg('已提交申请，耐心等待审核!', {icon: 1,time:2000});
}

/*图片-编辑*/
function picture_edit(title,url,id){
	var index = layer.open({
		type: 2,
		title: title,
		content: url
	});
	layer.full(index);
}

/*图片-删除*/
function picture_del(obj,id){
	layer.confirm('确认要删除吗？',function(index){
		$.ajax({
			type: 'POST',
			url: '',
			dataType: 'json',
			success: function(data){
				$(obj).parents("tr").remove();
				layer.msg('已删除!',{icon:1,time:1000});
			},
			error:function(data) {
				console.log(data.msg);
			},
		});		
	});
}
</script>
</body>
</html>