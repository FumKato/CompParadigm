/*
 * @(#)BorderDecorator.java
 *
 * Project:		JHotdraw - a GUI framework for technical drawings
 *				http://www.jhotdraw.org
 *				http://jhotdraw.sourceforge.net
 * Copyright:	© by the original author(s) and all contributors
 * License:		Lesser GNU Public License (LGPL)
 *				http://www.opensource.org/licenses/lgpl-license.html
 */

package CH.ifa.draw.figures;

import java.awt.*;
import java.util.*;

import CH.ifa.draw.framework.*;
import CH.ifa.draw.standard.*;

/**
 * BorderDecorator decorates an arbitrary Figure with
 * a border.
 *
 * @version <$CURRENT_VERSION$>
 */
public  class BorderDecorator extends DecoratorFigure {

	/*
	 * Serialization support.
	 */
	private static final long serialVersionUID = 1205601808259084917L;
	private int borderDecoratorSerializedDataVersion = 1;

	public BorderDecorator() {
	}

	public BorderDecorator(Figure figure) {
		super(figure);
	}

	/**
	 * Performs additional initialization code before the figure is decorated
	 * Subclasses may override this method.
	 */
	protected void initialize() {
	}

	/**
	 * Draws a the figure and decorates it with a border.
	 */
	public void draw(Graphics g) {
	}

	/**
	 * Gets the displaybox including the border.
	 */
	public Rectangle displayBox() {
		Rectangle r = getDecoratedFigure().displayBox();
		r.grow(getBorderOffset().x, getBorderOffset().y);
		return r;
	}

	/**
	 * Invalidates the figure extended by its border.
	 */
	public void figureInvalidated(FigureChangeEvent e) {
		Rectangle rect = e.getInvalidatedRectangle();
		rect.grow(getBorderOffset().x, getBorderOffset().y);
		super.figureInvalidated(new FigureChangeEvent(e.getFigure(), rect));
	}

	public Insets connectionInsets() {
		return null;
	}
}
