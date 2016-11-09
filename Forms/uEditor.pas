unit uEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Menus, uTypes, BCEditor.Editor.Base, BCEditor.Editor,
  BCEditor.Types, BCEditor.Editor.Marks, BCEditor.Editor.KeyCommands,
  Vcl.ExtCtrls;

type
  TEditorForm = class(TForm)
    Editor: TBCEditor;
    pTopLine: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditorChange(Sender: TObject);
    procedure EditorCaretChanged(ASender: TObject; X, Y: Integer);
    procedure EditorKeyPress(ASender: TObject; var AKey: Char);
    procedure EditorLeftMaginClick(ASender: TObject; AButton: TMouseButton; X, Y, ALine: Integer;
      AMark: TBCEditorMark);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    FFileName: string;
    FState: Integer;
    procedure SetFileName(const Value: string);
    procedure SetState(const Value: Integer);
  public
    { Public declarations }
    property FileName: string read FFileName write SetFileName;
    property State: Integer read FState write SetState;
  end;

  // var
  // fEditor: TfEditor;

resourcestring
  rsEditorQueryClose = 'Save changes to the file "%s"?';

implementation

{$R *.dfm}

uses uMain;

procedure TEditorForm.FormCreate(Sender: TObject);
begin
  pTopLine.Caption := '';
  pTopLine.Height := 1;

  Editor.Lines.Clear;
  Editor.Align := alClient;
  Editor.BorderStyle := bsNone;
  Editor.Scroll.Shadow.Visible := true;
  Editor.CompletionProposal.Enabled := false;
  Editor.RightMargin.Options := [];
  Editor.RightMargin.Position := 100;
  Editor.ActiveLine.Indicator.Visible := true;
  Editor.Undo.Options := [];
  // Editor.SpecialChars.Visible := true;
  // Editor.SpecialChars.EndOfLine.Visible := true;
  Editor.SpecialChars.EndOfLine.Style := eolPilcrow;

  Editor.OnChange := EditorChange;
  Editor.OnKeyPress := EditorKeyPress;
  Editor.OnCaretChanged := EditorCaretChanged;
  Editor.OnLeftMarginClick := EditorLeftMaginClick;

  if FileExists(ExtractFilePath(Application.ExeName) + 'Colors\Default.json') then
    Editor.Highlighter.Colors.LoadFromFile('Default.json');

  if FileExists(ExtractFilePath(Application.ExeName) + 'Highlighters\TMC.json') then
    Editor.Highlighter.LoadFromFile('TMC.json');

  // Editor.KeyCommands.Clear;
  // Editor.KeyCommands.Add(ecLineBreak, [], VK_RETURN);
  // Editor.KeyCommands.Add(ecLineBreak, [ssShift], VK_RETURN);
  // Editor.KeyCommands.Add(ecTab, [], VK_TAB);
  // Editor.KeyCommands.Add(ecShiftTab, [ssShift], VK_TAB);

  FState := stNew;
end;

procedure TEditorForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  answer: Word;
begin
  { if (FState = stEdit) or ((FState = stNew) and (Editor.Modified)) then
    begin
    answer := MessageBox(Handle, pchar(Format(rsEditorQueryClose, [Caption])), pchar('TM Complex'),
    MB_YESNOCANCEL + MB_ICONINFORMATION);
    case answer of
    ID_YES:
    if not Main.SaveDocument then
    begin
    CanClose := false;
    exit;
    end;
    ID_NO:
    // CanClose := false;
    ;
    ID_CANCEL:
    begin
    CanClose := false;
    exit;
    end;
    end;
    end;

    self.Hide;
    self.ManualFloat(rect(0, 0, 0, 0)); }
end;

procedure TEditorForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // self.Hide;
  // self.ManualFloat(rect(0, 0, 0, 0));
  Action := caFree;
end;

procedure TEditorForm.EditorCaretChanged(ASender: TObject; X, Y: Integer);
begin
  Main.StatusBar.Panels[STATUS_BAR_CARET].text := IntToStr(Editor.DisplayCaretY) + ':' +
    IntToStr(Editor.DisplayCaretX);
end;

procedure TEditorForm.EditorChange(Sender: TObject);
begin
  if (Main.ActiveEditor = self) and (FState <> stNew) then
    if Editor.Modified then
      FState := stEdit
    else
      FState := stSave;

  if Main.PageEditor.ActivePage.ImageIndex <> FState then
    Main.PageEditor.ActivePage.ImageIndex := FState;
end;

procedure TEditorForm.EditorKeyPress(ASender: TObject; var AKey: Char);
begin
  //
end;

procedure TEditorForm.EditorLeftMaginClick(ASender: TObject; AButton: TMouseButton;
  X, Y, ALine: Integer; AMark: TBCEditorMark);
begin
  //
end;

procedure TEditorForm.SetFileName(const Value: string);
begin
  FFileName := Value;
  Caption := StringReplace(ExtractFileName(FFileName), ExtractFileExt(FFileName), '', []);
end;

procedure TEditorForm.SetState(const Value: Integer);
begin
  FState := Value;
  if Main.PageEditor.PageCount > 0 then
    Main.PageEditor.ActivePage.ImageIndex := FState;
end;

end.