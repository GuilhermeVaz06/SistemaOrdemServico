object FSenha: TFSenha
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Login'
  ClientHeight = 150
  ClientWidth = 314
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 314
    Height = 150
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Label2: TLabel
      Left = 7
      Top = 6
      Width = 43
      Height = 16
      Caption = 'Usuario'
    end
    object Label1: TLabel
      Left = 7
      Top = 51
      Width = 36
      Height = 16
      Caption = 'Senha'
    end
    object ESenha: TEdit
      Left = 7
      Top = 68
      Width = 298
      Height = 24
      PasswordChar = '*'
      TabOrder = 1
    end
    object Panel2: TPanel
      Left = 0
      Top = 99
      Width = 314
      Height = 51
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      object BEntrar: TSpeedButton
        Left = 0
        Top = 0
        Width = 90
        Height = 51
        Align = alLeft
        Caption = 'Entrar'
        ImageIndex = 13
        Images = FMenuPrincipal.ImageList1
        OnClick = BEntrarClick
        ExplicitLeft = 8
        ExplicitHeight = 191
      end
      object BSair: TSpeedButton
        Left = 224
        Top = 0
        Width = 90
        Height = 51
        Align = alRight
        Caption = 'Sair'
        ImageIndex = 6
        Images = FMenuPrincipal.ImageList1
        OnClick = BSairClick
        ExplicitLeft = 8
      end
    end
    object EUsuario: TEdit
      Left = 7
      Top = 23
      Width = 298
      Height = 24
      TabOrder = 0
    end
  end
end
