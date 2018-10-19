unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB,
  Datasnap.DBClient, Datasnap.Win.MConnect, Datasnap.Win.SConnect,
  IdBaseComponent, IdComponent, IdCustomTCPServer, IdTCPServer,
  System.Win.ScktComp,IdContext,IdGlobal,IDSync, IdTCPConnection, IdTCPClient,
  IdHTTP, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent;

type
  TForm4 = class(TForm)
    Memo1: TMemo;
    IdTCPServer1: TIdTCPServer;
    Edit2: TEdit;
    IdTCPClient1: TIdTCPClient;
    NetHTTPClient1: TNetHTTPClient;
    Label1: TLabel;
    Memo2: TMemo;

    procedure FormActivate(Sender: TObject);
    procedure ServerSocket1Accept(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocket1ClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure Button1Click(Sender: TObject);
    procedure IdTCPServer1Execute(AContext: TIdContext);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Stream: TMemoryStream;
    FSize: Integer;
    writing: Boolean;
  public
    { Public declarations }
    Terminal : TStringList;
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

uses uCRC, uGPS;

procedure onLogin(imei: string; Serial: word;ip: string);
begin
  Form4.Memo1.Lines.Add(imei + ' logged in: '+ip+' '+ IntToStr(Serial));
end;

procedure TForm4.Button1Click(Sender: TObject);

begin

  IdTCPClient1.Host := '41.111.44.206';
  IdTCPClient1.Port:=strtoint(Edit2.Text);
  IdTCPClient1.Connect;
  //IdTCPClient1.Socket.WriteLn(Edit1.Text);



end;

procedure TForm4.Button2Click(Sender: TObject);
begin
 //
 IdTcpServer1.DefaultPort := strtoint(Edit2.Text);
 //IdTcpServer1.Active := True;

 {IdTCPClient1.Host := '41.105.58.201';
  IdTCPClient1.Port:=9090;
   IdTCPClient1.Connect;}
 //Memo1.Lines.Add('ready.....');
 //ClientSocket1.Active := True;
end;

procedure TForm4.Button3Click(Sender: TObject);
begin
    IdTcpServer1.Active := False;
    Memo1.Lines.Clear;
end;

procedure TForm4.FormActivate(Sender: TObject);
var
  LHTTP: TNetHTTPClient;
  Params: TStringList;
begin
  Terminal := TStringList.Create;
  IdTcpServer1.DefaultPort := strtoint(Edit2.Text);
  IdTcpServer1.Active := true;

  LHTTP := TNetHTTPClient.Create(nil);
  try
    Params := TStringList.Create;
    try
      Params.Add('test=hello');

    finally
      Params.Free;
    end;
  finally
    LHTTP.Free;
  end;

  Label1.Caption := 'Ready...................';

end;

procedure TForm4.FormCreate(Sender: TObject);
begin
  uGPS.onLogin(onLogin);
end;

function BytesToString(const Value: TBytes): WideString;
begin
  SetLength(Result, Length(Value) div SizeOf(WideChar));
  if Length(Result) > 0 then
    Move(Value[0], Result[1], Length(Value));
end;

procedure TForm4.IdTCPServer1Execute(AContext: TIdContext);
var
  s: String;
  aByte: Byte;
  start, information, serial, error, stop, data: TIdBytes;
  length, protocol: byte;
  crc: word;
  i: Integer;
begin
  {s := AContext.Connection.IOHandler.ReadLn();//AContext.Connection.IOHandler.ReadLn(IndyUTF16BigEndianEncoding);
    Memo1.Lines.Add(s);}

  Memo1.Lines.Add(AContext.Connection.Socket.Binding.PeerIP);
  uGPS.onRecieve(AContext.Connection.IOHandler, s, Terminal,AContext.Connection.Socket.Binding.PeerIP);
  Memo1.Lines.Add(s);
end;

procedure TForm4.ServerSocket1Accept(Sender: TObject; Socket: TCustomWinSocket);
begin
  Memo1.Lines.Add('RemoteAddress : '+Socket.RemoteAddress);
  Memo1.Lines.Add('RemoteHost : '+Socket.RemoteHost);
  Memo1.Lines.Add('LocalAddress : '+Socket.LocalAddress);
  Memo1.Lines.Add('LocalHost : '+Socket.LocalHost);


end;
procedure TForm4.ServerSocket1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
      RecvStr : String;
      Buffer:array[0..999] of Ansichar;

begin
    RecvStr := Socket.ReceiveText;
    //Socket.ReceiveBuf(Buffer,Socket.ReceiveLength);
    Memo1.Lines.Add('message : '+RecvStr);
    Memo1.Lines.Add('AnsiString : '+AnsiString(RecvStr));
    Memo1.Lines.Add(' : '+RecvStr);

  //Memo1.Lines.Add('message : '+Socket.ReceiveText());
  //ClientSocket1.Active := false;

end;

end.
