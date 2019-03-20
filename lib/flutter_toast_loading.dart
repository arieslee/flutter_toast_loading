library flutter_toast_loading;
import 'package:flutter/material.dart';
class FlutterToastLoading extends StatelessWidget{
    //子布局
    final Widget child;

    //加载中是否显示
    final bool loading;

    //进度提醒内容
    final String text;

    //文字样式
    final TextStyle textStyle;

    //加载中动画
    final Widget indicator;

    //加载动画的线条的宽度
    final double indicatorStrokeWidth;

    //加载动画的默认值 如果为非null，则该进度指示器的值为0.0，对应于没有进度，1.0对应于所有进度。
    final double indicatorValue;

    //加载动画的颜色值
    final Animation<Color> indicatorColor;

    //背景透明度
    final double backgroundColorAlpha;

    //有提示文字时的padding
    final double borderRadius;

    //有提示文字时的padding
    final double containerPadding;

    //文字的padding
    final EdgeInsets textPadding;

    //背影颜色
    final Color backgroundColor;


    FlutterToastLoading(
        {Key key,
            @required this.loading,
            this.text,
            this.textStyle = const TextStyle(color: Colors.white, fontSize: 16.0),
            this.indicatorStrokeWidth,
            this.indicatorValue,
            this.indicatorColor,
            this.indicator, // CircularProgressIndicator or flutter_spinkit
            this.backgroundColor = Colors.black87,
            this.backgroundColorAlpha = 0.6,
            this.borderRadius = 4.0,
            this.containerPadding = 20.0,
            this.textPadding = const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
            @required this.child})
        : assert(child != null),
            assert(loading != null),
            super(key: key);

    @override
    Widget build(BuildContext context) {
        List<Widget> _list = [child];
        Widget progressIndicator = indicator ?? CircularProgressIndicator(
            strokeWidth: indicatorStrokeWidth,
            value: indicatorValue,
            valueColor: indicatorColor,
        );
        if (loading) {
            Widget progress;
            if (text == null) {
                progress = Center(
                    child: progressIndicator,
                );
            } else {
                progress = Center(
                    child: Container(
                        padding: EdgeInsets.all(containerPadding),
                        decoration: BoxDecoration(
                            color: this.backgroundColor,
                            borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                                progressIndicator,
                                Container(
                                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                                    child: Text(
                                        text,
                                        style: textStyle,
                                    ),
                                )
                            ],
                        ),
                    ),
                );
            }
            // 背景颜色
            _list.add(Opacity(
                opacity: backgroundColorAlpha,
                child: ModalBarrier(color: this.backgroundColor),
            ));
            _list.add(progress);
        }
        return Stack(
            children: _list,
        );
    }
}