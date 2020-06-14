# SWLabels

SWLabels is a tool for conveniently printing text on [SpriteWidget](https://github.com/spritewidget/spritewidget) objects

It is very convenient for use in the following cases:
- for debugging when it is more convenient to see information directly on the screen, instead of using logs or a debugger
- to temporarily display the state of the application (for example, the score and life in games), while the graphics are not yet developed

You can see an [swlabels_example](https://github.com/iLnaar/swlabels_example) of using SWLabels,
and also watch a [demo video](https://youtu.be/DQN3YOOF1pk). This is an example work record.

A screenshot is taken from this example:

![altText](https://raw.githubusercontent.com/iLnaar/swlabels/master/assets/demo.png "SWLabels")

In the left part you can see two SWLabels with the headings "Status" and "Ball positions".
The first of them shows the current status of the application. In the second - the coordinates of
all the balls that continuously moving. To the right is SWLabels with the heading "Terminal".
He is so named because the lines in it will scroll up, as in ordinary terminals.

Lines in SWLabels are called text Labels (SWLabel objects). Information in them can be displayed
different ways:
- at the end of the list with the name of the label. The following output by name will replace existing text.
- by coordinates with the name of the label. The following output will also replace existing text.
- at the end of the list without specifying a label name. In this case, as soon as the number of rows reaches the maximum,
the lines will scroll up. This is a mode resembling a terminal or a log

For more details, see the example in the repository [swlabels_example](https://github.com/iLnaar/swlabels_example)