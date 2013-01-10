package CH.ifa.draw.aspects;

import java.awt.Point;
import java.awt.event.MouseEvent;

import CH.ifa.draw.framework.DrawingView;
import CH.ifa.draw.framework.FigureEnumeration;
import CH.ifa.draw.standard.AbstractTool;
import CH.ifa.draw.util.Undoable;
import CH.ifa.draw.util.UndoableAdapter;

public aspect DragTracker {
	public interface AbstractDragTracker {};
	
	private Figure AbstractDragTracker.fAnchorFigure;
	private int AbstractDragTracker.fLastX;
	private int AbstractDragTracker.fLastY;
	private boolean AbstractDragTracker.fMoved = false;
	private boolean isDragTracker = false;
	
	protected Undoable AbstractDragTracker.createUndoActivity() {
		return new DragTracker.UndoActivity(view(), new Point(fLastX, fLastY));
	}

	public static class UndoActivity extends UndoableAdapter {
		private Point myOriginalPoint;
		private Point myBackupPoint;
		
		public UndoActivity(DrawingView newDrawingView, Point newOriginalPoint) {
			super(newDrawingView);
			setOriginalPoint(newOriginalPoint);
			setUndoable(true);
			setRedoable(true);
		}

		/*
		 * Undo the activity
		 * @return true if the activity could be undone, false otherwise
		 */
		public boolean undo() {
			if (!super.undo()) {
				return false;
			}
			moveAffectedFigures(getBackupPoint(), getOriginalPoint());
			return true;
		}

		/*
		 * Redo the activity
		 * @return true if the activity could be redone, false otherwise
		 */
		public boolean redo() {
			if (!super.redo()) {
				return false;
			}
			moveAffectedFigures(getOriginalPoint(), getBackupPoint());
			return true;
		}
		public void setBackupPoint(Point newBackupPoint) {
			myBackupPoint = newBackupPoint;
		}
		
		public Point getBackupPoint() {
			return myBackupPoint;
		}
		
		public void setOriginalPoint(Point newOriginalPoint) {
			myOriginalPoint = newOriginalPoint;
		}
		
		public Point getOriginalPoint() {
			return myOriginalPoint;
		}
		
		public void moveAffectedFigures(Point startPoint, Point endPoint) {
			FigureEnumeration figures = getAffectedFigures();
			while (figures.hasMoreElements()) {
				figures.nextFigure().moveBy(endPoint.x - startPoint.x,
					endPoint.y - startPoint.y);
			}
		}
	}
	
	declare parents: CH.ifa.draw.standard.AbstractTool implements AbstractDragTracker;
	
	pointcut selectionDragTrackerUsed(AbstractTool tool, MouseEvent e, int x, int y): execution(void CH.ifa.draw.standard.SelectionTool.mouseDown(e, x, y)) && this(tool) && args(e, x, y) && if(tool.view().findHandle(e.getX(), e.getY()) == null) && if(tool.drawing().findFigure(e.getX(), e.getY()) != null);
	pointcut selectionMouseDowned(AbstractTool tool, MouseEvent e, int x, int y): execution(void CH.ifa.draw.standard.SelectionTool.mouseDown(e, x, y)) && this(tool) && args(e, x, y) && if(tool.isSelectAreaTracker);
	pointcut selectionMouseDraged(AbstractTool tool, MouseEvent e, int x, int y): execution(void CH.ifa.draw.standard.SelectionTool.mouseDrag(e, x, y)) && this(tool) && args(e, x, y) && if(tool.isSelectAreaTracker);
	pointcut selectionMouseUpped(AbstractTool tool, MouseEvent e, int x, int y): execution(void CH.ifa.draw.standard.SelectionTool.mouseUp(e, x, y)) && this(tool) && args(e, x, y) && if(tool.isSelectAreaTracker);
	pointcut selectionActivated(AbstractTool tool): execution(void CH.ifa.draw.standard.SelectionTool.activate()) && this(tool) && if(tool.isSelectAreaTracker);
	pointcut selectionDeactivated(AbstractTool tool): execution(void CH.ifa.draw.standard.SelectionTool.deactivate()) && this(tool) && if(tool.isSelectAreaTracker);
	
	after(AbstractTool tool, MouseEvent e, int x, int y): selectionDragTrackerUsed(tool, e, x, y) {
		tool.isDragTracker = true;
		tool.fAnchorFigure = tool.view().findHandle(e.getX(), e.getY()); 
	}
	
	after(AbstractTool tool, MouseEvent e, int x, int y): selectionMouseDowned(tool, e, x, y){
		tool.super.mouseDown(e, x, y);
		tool.fLastX = x;
		tool.fLastY = y;

		if (e.isShiftDown()) {
		   tool.view().toggleSelection(fAnchorFigure);
		   tool.fAnchorFigure = null;
		}
		else if (!tool.view().isFigureSelected(fAnchorFigure)) {
			tool.view().clearSelection();
			tool.view().addToSelection(fAnchorFigure);
		}
		tool.activate();
	}

	void around(AbstractTool tool, MouseEvent e, int x, int y): selectionMouseDrag(tool, e, x, y){
		tool.super.mouseDrag(e, x, y);
		tool.fMoved = (Math.abs(x - fAnchorX) > 4) || (Math.abs(y - fAnchorY) > 4);

		if (tool.fMoved) {
			FigureEnumeration figures = tool.getUndoActivity().getAffectedFigures();
			while (figures.hasMoreElements()) {
				figures.nextFigure().moveBy(x - fLastX, y - fLastY);
			}
		}
		tool.fLastX = x;
		tool.fLastY = y;
	}

	after(AbstractTool tool, MouseEvent e, int x, int y): selectionMouseUpped(tool, e, x, y){
		tool.super.mouseUp(e, x, y);
		tool.deactivate();
		tool.isDragTracker = false;
		tool.fChildExistence = false;
	}
	
	void around(AbstractTool tool): selectionActivated(tool) {
		tool.setUndoActivity(createUndoActivity());
		tool.getUndoActivity().setAffectedFigures(view().selectionElements());
	}
	
	void around(AbsractTool tool): selectionDeactivated(tool){
		if (tool.fMoved) {
			((DragTracker.UndoActivity)tool.getUndoActivity()).setBackupPoint(new Point(fLastX, fLastY));
		}
		else {
			tool.setUndoActivity(null);
		}
	}
}
