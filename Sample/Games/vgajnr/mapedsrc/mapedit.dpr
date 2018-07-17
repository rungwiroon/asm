program mapedit;

uses
  Forms,
  mainform in 'mainform.pas' {mform},
  graphtools in '..\..\units\graphtools.pas',
  spedit in 'spedit.pas' {eform},
  sizeform in 'sizeform.pas' {siform};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tmform, mform);
  Application.CreateForm(Teform, eform);
  Application.CreateForm(Tsiform, siform);
  Application.Run;
end.
