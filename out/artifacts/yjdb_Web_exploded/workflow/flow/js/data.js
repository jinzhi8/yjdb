var jsondata={
    "title":"10086网状流程",
    "nodes":{
        "demo_node_2":{
            "name":"问候语2",
            "left":300,
            "top":104,
            "type":"chat",
            "width":100,
            "height":24,
            "alt":true
        },
        "demo_node_3":{
            "name":"问候语3",
            "left":220,
            "top":260,
            "type":"chat",
            "width":100,
            "height":24,
            "alt":true
        }
    },
    "lines":{
        "demo_line_58":{
            "type":"tb",
            "M":180,
            "from":"demo_node_3",
            "to":"demo_node_2",
            "name":"送部门负责人"
        },
        "demo_line_60":{
            "type":"sl",
            
            "from":"demo_node_2",
            "to":"demo_node_3",
            "name":"送领导审核"
        }
    },
    "areas":{

    },
    "initNum":61
}