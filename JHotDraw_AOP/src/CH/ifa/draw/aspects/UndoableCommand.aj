package CH.ifa.draw.aspects;

public privileged aspect UndoableCommand {
	
	
	pointcut undoableExecute(AbstractUndoableCommand undoablecommand): execution(void CH.ifa.draw.standard.AbstractUndoableCommand+.execute()) && this(undoablecommand);
	
	void around(AbstractUndoableCommand undoablecommand): undoableExecute(undoablecommand) {
		undoablecommand.hasSelectionChanged = false;
		undoablecommand.view().addFigureSelectionListener(this);

		proceed(undoablecommand);

		Undoable undoableCommand = undoablecommand.getUndoActivity();
		if ((undoableCommand != null) && (undoableCommand.isUndoable())) {
			undoablecommand.getDrawingEditor().getUndoManager().pushUndo(undoableCommand);
			undoablecommand.getDrawingEditor().getUndoManager().clearRedos();
		}
		
		if (!undoablecommand.hasSelectionChanged || (undoablecommand.getDrawingEditor().getUndoManager().getUndoSize() == 1)) {
			undoablecommand.getDrawingEditor().figureSelectionChanged(view());
		}

		undoablecommand.view().addFigureSelectionListener(this);
	}
}
