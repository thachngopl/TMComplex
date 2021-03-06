unit uEditorEncoding;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TEditorEncodingForm = class(TForm)
    BtnOk: TButton;
    BtnCancel: TButton;
    cbEncoding: TComboBox;
    lEncoding: TLabel;
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses uEncoding, uLanguage;

procedure TEditorEncodingForm.FormCreate(Sender: TObject);
begin
  FillEncodingItems(cbEncoding);
  SendMessage(cbEncoding.Handle, WM_UPDATEUISTATE, MakeLong(UIS_SET, UISF_HIDEFOCUS), 0);
end;

procedure TEditorEncodingForm.FormShow(Sender: TObject);
begin
  UpdateLanguage(Self, lngRus);
end;

procedure TEditorEncodingForm.BtnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TEditorEncodingForm.BtnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
