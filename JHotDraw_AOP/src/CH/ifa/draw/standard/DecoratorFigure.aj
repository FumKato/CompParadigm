/*
 * @(#)DecoratorFigure.java
 *
 * Project:		JHotdraw - a GUI framework for technical drawings
 *				http://www.jhotdraw.org
 *				http://jhotdraw.sourceforge.net
 * Copyright:	© by the original author(s) and all contributors
 * License:		Lesser GNU Public License (LGPL)
 *				http://www.opensource.org/licenses/lgpl-license.html
 */

package CH.ifa.draw.standard;

import CH.ifa.draw.util.*;
import CH.ifa.draw.framework.*;

import java.awt.*;
import java.util.*;
import java.io.*;

/**
 * DecoratorFigure can be used to decorate other figures with
 * decorations like borders. Decorator forwards all the
 * methods to their contained figure. Subclasses can selectively
 * override these methods to extend and filter their behavior.
 * <hr>
 * <b>Design Patterns</b><P>
 * <img src="images/red-ball-small.gif" width=6 height=6 alt=" o ">
 * <b><a href=../pattlets/sld014.htm>Decorator</a></b><br>
 * DecoratorFigure is a decorator.
 *
 * @see Figure
 *
 * @version <$CURRENT_VERSION$>
 */

public abstract class DecoratorFigure extends AbstractFigure implements FigureChangeListener {

	/*
	 * Serialization support.
	 */
	private static final long serialVersionUID = 8993011151564573288L;
	private int decoratorFigureSerializedDataVersion = 1;

	public DecoratorFigure() {
		initialize();
	}

	/**
	 * Constructs a DecoratorFigure and decorates the passed in figure.
	 */
	public DecoratorFigure(Figure figure) {
		initialize();
	}

	/**
	 * Performs additional initialization code before the figure is decorated.
	 * Subclasses may override this method.
	 */
	protected void initialize() {
	}

	public Insets connectionInsets() {
		return null;
	}
	
	/**
	 * Forwards the canConnect to its contained figure..
	 */
	public boolean canConnect() {
		return false;
	}

	/**
	 * Forwards containsPoint to its contained figure.
	 */
	public boolean containsPoint(int x, int y) {
		return getDecoratedFigure().containsPoint(x, y);
	}

	/**
	 * Removes the decoration from the contained figure.
	 */
	public Figure peelDecoration() {
		return null;
	}

	/*public Figure getDecoratedFigure() {
		return fComponent;
	}*/

	/**
	 * Forwards displayBox to its contained figure.
	 */
	public Rectangle displayBox() {
		return null;
	}

	/**
	 * Forwards basicDisplayBox to its contained figure.
	 */
	public void basicDisplayBox(Point origin, Point corner) {
	}

	/**
	 * Forwards draw to its contained figure.
	 */
	public void draw(Graphics g) {
	}

	/**
	 * Forwards findFigureInside to its contained figure.
	 */
	public Figure findFigureInside(int x, int y) {
		return null;
	}

	/**
	 * Forwards handles to its contained figure.
	 */
	public Vector handles() {
		return null;
	}

	/**
	 * Forwards includes to its contained figure.
	 */
	public boolean includes(Figure figure) {
		return false;
	}

	/**
	 * Forwards moveBy to its contained figure.
	 */
	public void moveBy(int x, int y) {
	}

	/**
	 * Forwards basicMoveBy to its contained figure.
	 */
	protected void basicMoveBy(int x, int y) {
		// this will never be called
	}

	/**
	 * Releases itself and the contained figure.
	 */
	public void release() {
	}

	/**
	 * Propagates invalidate up the container chain.
	 * @see FigureChangeListener
	 */
	public void figureInvalidated(FigureChangeEvent e) {
		if (listener() != null) {
			listener().figureInvalidated(e);
		}
	}

	public void figureChanged(FigureChangeEvent e) {
	}

	public void figureRemoved(FigureChangeEvent e) {
	}

	/**
	 * Propagates figureRequestUpdate up the container chain.
	 * @see FigureChangeListener
	 */
	public  void figureRequestUpdate(FigureChangeEvent e) {
		if (listener() != null) {
			listener().figureRequestUpdate(e);
		}
	}

	/**
	 * Propagates the removeFromDrawing request up to the container.
	 * @see FigureChangeListener
	 */
	public void figureRequestRemove(FigureChangeEvent e) {
		if (listener() != null) {
			listener().figureRequestRemove(new FigureChangeEvent(this));
		}
	}

	/**
	 * Forwards figures to its contained figure.
	 */
	public FigureEnumeration figures() {
		return null;
	}

	/**
	 * Forwards decompose to its contained figure.
	 */
	public FigureEnumeration decompose() {
		return null;
	}

	/**
	 * Forwards setAttribute to its contained figure.
	 */
	public void setAttribute(String name, Object value) {
	}

	/**
	 * Forwards getAttribute to its contained figure.
	 */
	public Object getAttribute(String name) {
		return null;
	}

	/**
	 * Returns the locator used to located connected text.
	 */
	public Locator connectedTextLocator(Figure text) {
		return null;
	}

	/**
	 * Returns the Connector for the given location.
	 */
	public Connector connectorAt(int x, int y) {
		return null;
	}

	/**
	 * Forwards the connector visibility request to its component.
	 */
	public void connectorVisibility(boolean isVisible) {
	}

	/**
	 * Writes itself and the contained figure to the StorableOutput.
	 */
	public void write(StorableOutput dw) {
		super.write(dw);
		dw.writeStorable(getDecoratedFigure());
	}

	/**
	 * Reads itself and the contained figure from the StorableInput.
	 */
	public void read(StorableInput dr) throws IOException {
		super.read(dr);
		decorate((Figure)dr.readStorable());
	}

	private void readObject(ObjectInputStream s)
		throws ClassNotFoundException, IOException {

		s.defaultReadObject();

		getDecoratedFigure().addToContainer(this);
	}
}
