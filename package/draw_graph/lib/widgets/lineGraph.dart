import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:draw_graph/models/feature.dart';

class LineGraphPainter extends CustomPainter {
  final List<String> labelX;
  final List<String> labelY;
  final List<int> list;
  final String fontFamily;
  final Color graphColor;
  final double graphOpacity;
  LineGraphPainter({
    this.labelX,
    this.labelY,
    this.list,
    this.fontFamily,
    this.graphColor,
    this.graphOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double _offsetX = 1;
    for (int i = 0; i < labelY.length; i++) {
      if (labelY[i].length > _offsetX) {
        _offsetX = labelY[i].length.toDouble();
      }
    }

    _offsetX *= 7;
    _offsetX += 2 * size.width / 20;
    Size margin = Size(_offsetX, size.height / 20);
    Size graph = Size(
      size.width,
      size.height,
    );
    Size cell = Size(
      (graph.width - margin.width) / (list.length),
      graph.height / labelY.length,
    );

    // drawAxis(canvas, graph, margin);
    drawLabelsY(canvas, size, margin, graph, cell);
    //  drawLabelsX(canvas, Size(_offsetX, margin.height / 20), graph, cell);
    drawGraphnew(
      canvas,
      graph,
      cell,
      margin,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void drawAxis(Canvas canvas, Size graph, Size margin) {
    Paint linePaint = Paint()
      ..color = graphColor
      ..strokeWidth = 1;

    Offset xEnd =
        Offset(graph.width + 2 * margin.width, graph.height + margin.height);
    Offset yStart = Offset(margin.width, 0);

    //X-Axis & Y-Axis
    canvas.drawLine(
        Offset(margin.width, graph.height + margin.height), xEnd, linePaint);
    canvas.drawLine(
        yStart, Offset(margin.width, graph.height + margin.height), linePaint);

    //Arrow heads
    canvas.drawLine(xEnd, Offset(xEnd.dx - 5, xEnd.dy - 5), linePaint);
    canvas.drawLine(xEnd, Offset(xEnd.dx - 5, xEnd.dy + 5), linePaint);
    canvas.drawLine(yStart, Offset(yStart.dx - 5, yStart.dy + 5), linePaint);
    canvas.drawLine(yStart, Offset(yStart.dx + 5, yStart.dy + 5), linePaint);
  }

  void drawLabelsY(
      Canvas canvas, Size size, Size margin, Size graph, Size cell) {
    for (int i = 0; i < labelY.length; i++) {
      TextSpan span = new TextSpan(
        style: new TextStyle(
          color: graphColor,
          fontFamily: fontFamily,
        ),
        text: labelY[i],
      );
      TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      tp.layout();

      double textSize = tp.height;

      tp.paint(
        canvas,
        new Offset(
          20,
          graph.height - (i) * cell.height - textSize,
        ),
      );
    }
  }

  void drawLabelsX(Canvas canvas, Size margin, Size graph, Size cell) {
    for (int i = 0; i < labelX.length; i++) {
      TextSpan span = new TextSpan(
        style: new TextStyle(
          color: graphColor,
          fontFamily: fontFamily,
        ),
        text: labelX[i],
      );
      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(
        canvas,
        new Offset(
          margin.width + cell.width * i - 16,
          margin.height + graph.height + 10,
        ),
      );
    }
  }

  void drawGraph(
      Feature feature, Canvas canvas, Size graph, Size cell, Size margin) {
    Paint fillPaint = Paint()
      ..color = feature.color.withOpacity(graphOpacity)
      ..style = PaintingStyle.fill;
    Paint strokePaint = Paint()
      ..color = feature.color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    Path path = Path();
    Path linePath = Path();
    print("=test===margin.width==${margin.width}====");
    print("=test===margin.width==${margin.width}====");
    print(
        "=test===graph.height + margin.height==${graph.height + margin.height}====");
    print(
        "=test===margin.height + graph.height - feature.data[0] * graph.height==${margin.height + graph.height - feature.data[0] * graph.height}====");
    path.moveTo(margin.width, graph.height + margin.height);
    path.lineTo(
      margin.width,
      margin.height + graph.height - feature.data[0] * graph.height,
    );
    linePath.moveTo(
      margin.width,
      margin.height + graph.height + 8 - feature.data[0] * graph.height,
    );
    int i = 0;
    List<int> list = [];
    list.add(8);
    list.add(10);
    list.add(15);
    list.add(20);
    list.add(20);
    list.add(30);
    for (i = 1; i < labelX.length && i < feature.data.length; i++) {
      if (feature.data[i] > 1) {
        feature.data[i] = 1;
      }
      if (feature.data[i] < 0) {
        feature.data[i] = 0;
      }

      path.lineTo(
        margin.width + i * cell.width,
        margin.height + graph.height - feature.data[i] * graph.height,
      );

      print("======feature.data[i]=${feature.data[i]}====");
      /*=======dot point============*/
      final pointMode = PointMode.points;
      final points = [
        Offset(margin.width + i * cell.width,
            margin.height + graph.height - feature.data[i] * graph.height)
      ];
      final paint = Paint()
        ..color = feature.color
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round;
      canvas.drawPoints(pointMode, points, paint);
      /*=================*/

      linePath.lineTo(
        margin.width + i * cell.width,
        margin.height + graph.height - feature.data[i] * graph.height,
      );
    }
    // path.lineTo(
    //     margin.width + (feature.data.length - 1) * cell.width, margin.height);
    path.lineTo(
      margin.width + cell.width * (i - 1),
      margin.height + graph.height,
    );
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(linePath, strokePaint);
  }

  void drawGraphnew(Canvas canvas, Size graph, Size cell, Size margin) {
    // list.add(8);
    Paint fillPaint = Paint()
      ..color = Colors.green.withOpacity(graphOpacity)
      ..style = PaintingStyle.fill;
    Paint strokePaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    Path path = Path();
    Path linePath = Path();
    print("=test===margin.width==${margin.width}====");
    print("=test===margin.width==${margin.width}====");
    print(
        "=test===graph.height + margin.height==${graph.height + margin.height}====");
    int marginBottom = 5;
    path.moveTo(margin.width, graph.height - marginBottom);
    path.lineTo(
      margin.width,
      graph.height - marginBottom,
    );
    linePath.moveTo(
      margin.width,
      graph.height - marginBottom,
    );

    int i = 0;
    final pointMode = PointMode.points;

    for (int i = 0; i < list.length; i++) {
      final points = [
        Offset(margin.width + i * cell.width,
            graph.height - (list[i] + marginBottom))
      ];

      final paint = Paint()
        ..color = Colors.green
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round;
      canvas.drawPoints(pointMode, points, paint);
      linePath.lineTo(
        margin.width + i * cell.width,
        graph.height - (list[i] + marginBottom),
      );
    }

    /* for (i = 1; i < labelX.length && i < feature.data.length; i++) {
      if (feature.data[i] > 1) {
        feature.data[i] = 1;
      }
      if (feature.data[i] < 0) {
        feature.data[i] = 0;
      }

      path.lineTo(
        margin.width + i * cell.width,
        margin.height + graph.height - feature.data[i] * graph.height,
      );

      print("======feature.data[i]=${feature.data[i]}====");
      */ /*=======dot point============*/ /*
      final pointMode = PointMode.points;
      final points = [
        Offset(margin.width + i * cell.width,
            margin.height + graph.height - feature.data[i] * graph.height)
      ];
      final paint = Paint()
        ..color = feature.color
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round;
      canvas.drawPoints(pointMode, points, paint);
      */ /*=================*/ /*

      linePath.lineTo(
        margin.width + i * cell.width,
        margin.height + graph.height - feature.data[i] * graph.height,
      );
    }*/
    // path.lineTo(
    //     margin.width + (feature.data.length - 1) * cell.width, margin.height);
    /* path.lineTo(
      margin.width + cell.width * (i - 1),
      margin.height + graph.height,
    );*/
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(linePath, strokePaint);
  }
}
