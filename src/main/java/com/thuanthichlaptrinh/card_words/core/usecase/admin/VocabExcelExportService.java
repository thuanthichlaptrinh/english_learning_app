package com.thuanthichlaptrinh.card_words.core.usecase.admin;

import com.thuanthichlaptrinh.card_words.core.domain.Vocab;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.VocabRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class VocabExcelExportService {

    private final VocabRepository vocabRepository;

    @Transactional(readOnly = true)
    public byte[] exportAllVocabsToExcel() throws IOException {
        log.info("Bắt đầu xuất tất cả từ vựng ra Excel");

        // Lấy tất cả vocab từ database
        List<Vocab> vocabs = vocabRepository.findAll();
        log.info("Tìm thấy {} từ vựng để xuất", vocabs.size());

        // Tạo workbook và sheet
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Vocabulary");

            // Tạo header styles
            CellStyle headerStyle = createHeaderStyle(workbook);
            CellStyle dataStyle = createDataStyle(workbook);

            // Tạo header row
            Row headerRow = sheet.createRow(0);
            String[] headers = {
                    "STT", "Word", "Transcription", "Meaning (Vietnamese)",
                    "Interpret", "Example Sentence", "CEFR Level",
                    "Types", "Topic", "Image URL", "Audio URL", "Credit"
            };

            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            // Điền dữ liệu
            int rowNum = 1;
            for (Vocab vocab : vocabs) {
                Row row = sheet.createRow(rowNum++);

                // STT
                createStyledCell(row, 0, rowNum - 1, dataStyle);

                // Word
                createStyledCell(row, 1, vocab.getWord(), dataStyle);

                // Transcription
                createStyledCell(row, 2, vocab.getTranscription(), dataStyle);

                // Meaning Vietnamese
                createStyledCell(row, 3, vocab.getMeaningVi(), dataStyle);

                // Interpret
                createStyledCell(row, 4, vocab.getInterpret(), dataStyle);

                // Example Sentence
                createStyledCell(row, 5, vocab.getExampleSentence(), dataStyle);

                // CEFR
                createStyledCell(row, 6, vocab.getCefr(), dataStyle);

                // Types (join multiple types with comma)
                String types = vocab.getTypes().stream()
                        .map(type -> type.getName())
                        .collect(Collectors.joining(", "));
                createStyledCell(row, 7, types, dataStyle);

                // Topic
                String topic = vocab.getTopic() != null ? vocab.getTopic().getName() : "";
                createStyledCell(row, 8, topic, dataStyle);

                // Image URL
                createStyledCell(row, 9, vocab.getImg(), dataStyle);

                // Audio URL
                createStyledCell(row, 10, vocab.getAudio(), dataStyle);

                // Credit
                createStyledCell(row, 11, vocab.getCredit(), dataStyle);
            }

            // Auto-size columns
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
                // Set minimum width
                int currentWidth = sheet.getColumnWidth(i);
                if (currentWidth < 3000) {
                    sheet.setColumnWidth(i, 3000);
                }
                // Set maximum width for long text columns
                if (i >= 3 && i <= 5 && currentWidth > 15000) {
                    sheet.setColumnWidth(i, 15000);
                }
            }

            // Freeze header row
            sheet.createFreezePane(0, 1);

            // Write to byte array
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            workbook.write(outputStream);

            log.info("Xuất Excel thành công với {} từ vựng", vocabs.size());
            return outputStream.toByteArray();
        }
    }

    /**
     * Tạo style cho header
     */
    private CellStyle createHeaderStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();

        // Background color
        style.setFillForegroundColor(IndexedColors.LIGHT_BLUE.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);

        // Border
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);

        // Font
        Font font = workbook.createFont();
        font.setBold(true);
        font.setFontHeightInPoints((short) 11);
        font.setColor(IndexedColors.BLACK.getIndex());
        style.setFont(font);

        // Alignment
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);

        // Text wrap
        style.setWrapText(true);

        return style;
    }

    /**
     * Tạo style cho data cells
     */
    private CellStyle createDataStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();

        // Border
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);

        // Border color
        style.setBottomBorderColor(IndexedColors.GREY_25_PERCENT.getIndex());
        style.setTopBorderColor(IndexedColors.GREY_25_PERCENT.getIndex());
        style.setRightBorderColor(IndexedColors.GREY_25_PERCENT.getIndex());
        style.setLeftBorderColor(IndexedColors.GREY_25_PERCENT.getIndex());

        // Font
        Font font = workbook.createFont();
        font.setFontHeightInPoints((short) 10);
        style.setFont(font);

        // Alignment
        style.setVerticalAlignment(VerticalAlignment.TOP);

        // Text wrap
        style.setWrapText(true);

        return style;
    }

    /**
     * Tạo cell với style và giá trị String
     */
    private void createStyledCell(Row row, int column, String value, CellStyle style) {
        Cell cell = row.createCell(column);
        cell.setCellValue(value != null ? value : "");
        cell.setCellStyle(style);
    }

    /**
     * Tạo cell với style và giá trị Number
     */
    private void createStyledCell(Row row, int column, int value, CellStyle style) {
        Cell cell = row.createCell(column);
        cell.setCellValue(value);
        cell.setCellStyle(style);
    }
}
