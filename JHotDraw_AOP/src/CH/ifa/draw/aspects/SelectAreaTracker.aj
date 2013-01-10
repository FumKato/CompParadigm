package CH.ifa.draw.aspects;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.event.MouseEvent;

import CH.ifa.draw.framework.Figure;
import CH.ifa.draw.framework.FigureEnumeration;
import CH.ifa.draw.standard.AbstractTool;

public privileged aspect SelectAreaTracker {
	
	public interface AbstractSelectAreaTracker {};
	
	private boolean AbstractHandleTracker.isSelectAreaTracker = false;
	private Rectangle CH.ifa.draw.standard.AbstractTool.fSelectGroup;
	
	declare parents: CH.ifa.draw.standard.AbstractTool implements AbstractHandleTracker;
	
	private void CH.ifa.draw.standard.AbstractTool.rubberBand(int x1, int y1, int x2, int y2) {
		fSelectGroup = new Rectangle(new Point(x1, y1));
		fSelectGroup.add(new Point(x2, y2));
		drawXORRect(fSelectGroup);
	}

	private void CH.ifa.draw.standard.AbstractTool.eraseRubberBand() {
		drawXORRect(fSelectGroup);
	}

	private void CH.ifa.draw.standard.AbstractTool.AbstractTool.drawXORRect(Rectangle r) {
		Graphics g = view().getGraphics();
		if ( g != null ) {
			try {
				g.setXORMode(view().getBackground());
				g.setColor(Color.black);
				g.drawRect(r.x, r.y, r.width, r.height);
			}
			finally {
				g.dispose(); // SF bugtracker id: #490663
			}
		}
	}

	private void CH.ifa.draw.standard.AbstractTool.selectGroup(boolean toggle) {
		FigureEnumeration k = drawing().figuresReverse();
		while (k.hasMoreElements()) {
			Figure figure = k.nextFigure();
			Rectangle r2 = figure.displayBox();
			if (fSelectGroup.contains(r2.x, r2.y) && fSelectGroup.contains(r2.x+r2.width, r2.y+r2.height)) {
				if (toggle) {
					view().toggleSelection(figure);
				}
				else {
					view().addToSelection(figure);
				}
			}
		}
	}
	
	
	pointcut selectionSelectAreaTrackerUsed(AbstractTool tool, MouseEvent e, int x, int y): execution(void CH.ifa.draw.standard.SelectionTool.mouseDown(e, x, y)) && this(tool) && args(e, x, y) && if(tool.view().findHandle(e.getX(), e.getY()) == null) && if(tool.drawing().findFigure(e.getX(), e.getY()) == null);
	pointcut selectionMouseDowned(AbstractTool tool, MouseEvent e, int x, int y): execution(void CH.ifa.draw.standard.SelectionTool.mouseDown(e, x, y)) && this(tool) && args(e, x, y) && if(tool.isSelectAreaTracker);
	pointcut selectionMouseDraged(AbstractTool tool, MouseEvent e, int x, int y): execution(void CH.ifa.draw.standard.SelectionTool.mouseDrag(e, x, y)) && this(tool) && args(e, x, y) && if(tool.isSelectAreaTracker);
	pointcut selectionMouseUpped(AbstractTool tool, MouseEvent e, int x, int y): execution(void CH.ifa.draw.standard.SelectionTool.mouseUp(e, x, y)) && this(tool) && args(e, x, y) && if(tool.isSelectAreaTracker);
	pointcut selectionActivated(AbstractTool tool): execution(void CH.ifa.draw.standard.SelectionTool.activate()) && this(tool) && if(tool.isSelectAreaTracker);
	pointcut selectionDeactivated(AbstractTool tool): execution(void CH.ifa.draw.standard.SelectionTool.deactivate()) && this(tool) && if(tool.isSelectAreaTracker);
	
	pointcut dragNDropSelectAreaTrackerUsed(AbstractTool tool, MouseEvent e, int x, int y): execution(void CH.ifa.draw.contrib.DragNDropTool.mouseDown(e,x,y)) && this(tool) && args(e, x, y) && if(tool.view().findHandle(e.getX(), e.getY()) == null) && if(tool.drawing().findFigure(e.getX(), e.getY()) == null);
	pointcut dragNDropMouseDowned(AbstractTool tool, MouseEvent e, int x, int y): execution(void CH.ifa.draw.standard.DragNDropTool.mouseDown(e, x, y)) && this(tool) && args(e, x, y) && if(tool.isSelectAreaTracker);
	pointcut dragNDropMouseDraged(AbstractTool tool, MouseEvent e, int x, int y): execution(void CH.ifa.draw.standard.DragNDropTool.mouseDrag(e, x, y)) && this(tool) && args(e, x, y) && if(tool.isSelectAreaTracker);
	pointcut dragNDropMouseUpped(AbstractTool tool, MouseEvent e, int x, int y): execution(void CH.ifa.draw.standard.SelectionTool.mouseUp(e, x, y)) && this(tool) && args(e, x, y) && if(tool.isSelectAreaTracker);	
	
	after(AbstractTool tool, MouseEvent e, int x, int y): selectionSelectAreaTrackerUsed(tool, e, x, y) {
		tool.isSelectAreaTracker = true;
	}

	after(AbstractTool tool, MouseEvent e, int x, int y): dragNDropSelectAreaTrackerUsed(tool, e, x, y) {
		tool.isSelectAreaTracker = true;
	}
	
	after(AbstractTool tool, MouseEvent e, int x, int y):dragNDropMouseDowned(tool, e, x, y) {
		// use event coordinates to supress any kind of
		// transformations like constraining points to a grid
		tool.super.mouseDown(e, e.getX(), e.getY());
		tool.rubberBand(fAnchorX, fAnchorY, fAnchorX, fAnchorY);
	}

	void around(AbstractTool tool, MouseEvent e, int x, int y): dragNDropMouseDraged(tool, e, x, y){
		tool.super.mouseDrag(e, x, y);
		tool.eraseRubberBand();
		tool.rubberBand(fAnchorX, fAnchorY, x, y);
	}

	after(AbstractTool tool, MouseEvent e, int x, int y): dragNDropMouseDraged(tool, e, x, y) {
		tool.super.mouseUp(e, x, y);
		tool.eraseRubberBand();
		tool.selectGroup(e.isShiftDown());
		tool.isSelectAreaTracker = false;
		tool.fChildExistence = false;
	}
	
	after(AbstractTool tool, MouseEvent e, int x, int y): selectionMouseDowned(tool, e, x, y){
		// use event coordinates to supress any kind of
		// transformations like constraining points to a grid
		tool.super.mouseDown(e, e.getX(), e.getY());
		tool.rubberBand(fAnchorX, fAnchorY, fAnchorX, fAnchorY);
		tool.activate();
	}

	void around(AbstractTool tool, MouseEvent e, int x, int y): selectionMouseDrag(tool, e, x, y){
		tool.super.mouseDrag(e, x, y);
		tool.eraseRubberBand();
		tool.rubberBand(fAnchorX, fAnchorY, x, y);
	}

	after(AbstractTool tool, MouseEvent e, int x, int y): selectionMouseUpped(tool, e, x, y){
		super.mouseUp(e, x, y);
		eraseRubberBand();
		selectGroup(e.isShiftDown());
		deactivate();
		isSelectAreaTracker = false;
		fChildExistence = false;
	}
	
	void around(AbstractTool tool): selectionActivated(tool) {
		tool.super.activate();
	}
	
	void around(AbsractTool tool): selectionDeactivated(tool){
		tool.super.deactivate();
	}
}
