package com.kizsoft.yjdb.utils;

import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ExcelUtils {
    /**
     * 多行表头
     * dataList：导出的数据；sheetName：表头名称； head0：表头第一行列名；headnum0：第一行合并单元格的参数
     * widths：表格宽度；detail：导出的表体字段
     */
    public static void reportMergeXls(HttpServletRequest request,
                                      HttpServletResponse response, List<Map<String, Object>> dataList,
                                      String sheetName, String[] head0, String[] headnum0,
                                      int[] widths, String[] detail, String date)
            throws Exception {
        String confXmlName = File.separator + "configprop" + File.separator + "pldc.xls";
        String path = new File(ExcelUtils.class.getResource("/").getPath()) + confXmlName;

        HSSFWorkbook workbook = new HSSFWorkbook(new FileInputStream(new File(path)));
        workbook.setSheetName(0, sheetName);
        HSSFSheet sheet = workbook.getSheetAt(0);
        // 表头标题样式
        HSSFFont headfont = workbook.createFont();
        headfont.setFontName("宋体");
        headfont.setFontHeightInPoints((short) 22);// 字体大小
        HSSFCellStyle headstyle = workbook.createCellStyle();
        headstyle.setFont(headfont);
        headstyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);// 左右居中
        headstyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 上下居中
        headstyle.setLocked(true);
        // 表头时间样式
        HSSFFont datefont = workbook.createFont();
        datefont.setFontName("宋体");
        datefont.setFontHeightInPoints((short) 12);// 字体大小
        HSSFCellStyle datestyle = workbook.createCellStyle();
        datestyle.setFont(datefont);
        datestyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);// 左右居中
        datestyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 上下居中
        datestyle.setLocked(true);
        // 列名样式
        HSSFFont font = workbook.createFont();
        font.setFontName("宋体");
        font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);//粗体显示
        font.setFontHeightInPoints((short) 12);// 字体大小
        HSSFCellStyle style = workbook.createCellStyle();
        style.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
        style.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
        style.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
        style.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
        style.setFont(font);
        style.setWrapText(true);
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER);// 左右居中
        style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 上下居中
        style.setLocked(true);
        // 普通单元格样式（中文）
        HSSFFont font2 = workbook.createFont();
        font2.setFontName("宋体");
        font2.setFontHeightInPoints((short) 12);
        HSSFCellStyle style2 = workbook.createCellStyle();
        style2.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
        style2.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
        style2.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
        style2.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
        style2.setFont(font2);
        style2.setAlignment(HSSFCellStyle.ALIGN_CENTER);// 左右居中
        style2.setWrapText(true); // 换行
        style2.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 上下居中
        // 设置列宽  （第几列，宽度）
        for (int i = 0; i < widths.length; i++) {
            sheet.setColumnWidth(i, widths[i]);
        }
        sheet.setDefaultRowHeight((short) 1500);//设置行高
        // 第一行表头标题
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, head0.length - 1));
        HSSFRow row = sheet.createRow(0);
        row.setHeight((short) 0x349);
        HSSFCell cell = row.createCell(0);
        cell.setCellStyle(headstyle);
        cell.setCellValue(date);
        // 第二行表头列名
        row = sheet.createRow(1);
        row.setHeight((short) 0x300);
        for (int i = 0; i < head0.length; i++) {
            cell = row.createCell(i);
            cell.setCellValue(head0[i]);
            cell.setCellStyle(style);
        }
        //动态合并单元格
        for (int i = 0; i < headnum0.length; i++) {
            String[] temp = headnum0[i].split(",");
            Integer startrow = Integer.parseInt(temp[0]);
            Integer overrow = Integer.parseInt(temp[1]);
            Integer startcol = Integer.parseInt(temp[2]);
            Integer overcol = Integer.parseInt(temp[3]);
            sheet.addMergedRegion(new CellRangeAddress(startrow, overrow,
                    startcol, overcol));
        }

        // 设置列值-内容
        for (int i = 0; i < dataList.size(); i++) {
            row = sheet.createRow(i + 2);
            for (int j = 0; j < detail.length; j++) {
                Map tempmap = (HashMap) dataList.get(i);
                Object data = tempmap.get(detail[j]);
                String d = data == null ? "无" : data.toString();
                //创建字体加粗样式
                HSSFFont fonts = workbook.createFont();
                fonts.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
                //创建富文本编辑器
                HSSFRichTextString richString = new HSSFRichTextString(d);
               /* if(d.length() > 7) {
                    richString.applyFont(0, 7, fonts);
                }*/

                cell = row.createCell(j);
                cell.setCellStyle(style2);
                cell.setCellType(HSSFCell.CELL_TYPE_STRING);
                cell.setCellValue(richString);
            }
        }
        ServletOutputStream output = null;
        try {
            output = response.getOutputStream();
            response.reset();
            response.setHeader("Content-disposition", "attachment; filename=" + URLEncoder.encode(sheetName + ".xls", "utf-8"));
            response.setContentType("application/msexcel");
            workbook.write(output);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (output != null) {
                output.close();
            }
        }
    }
}
