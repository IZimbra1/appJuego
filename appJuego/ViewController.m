//
//  ViewController.m
//  appJuego
//
//  Created by jimbo on 12/10/24.
//

#import "ViewController.h"

@interface ViewController ()


@property (weak, nonatomic) IBOutlet UILabel *labelProgreso;





@property (weak, nonatomic) IBOutlet UILabel *labelIntentos;



@property (weak, nonatomic) IBOutlet UITextField *textfieldIntentos;

- (IBAction)botonIntento:(id)sender;


//variables
@property (nonatomic) NSArray *palabras;
@property (nonatomic) NSString *lapalabra;
@property (nonatomic) NSString *hastahora;
@property (nonatomic) NSMutableString *usadas;
@property (nonatomic) int errores;
@property (nonatomic) int maxerror;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //setup
    self.maxerror = 8;
    self.palabras = @[@"amor",@"escarlata",@"sangre",@"veneno",@"eternidad",@"venganza",@"dos",@"sacrificio",@"madre",
                      @"ritual",@"rezo",@"herejia",@"infierno",@"soledad",@"nublado",@"locura",@"diosa",@"observadores",@"adopta",@"nosotros"];
    self.lapalabra = [self.palabras objectAtIndex:arc4random_uniform((uint32_t) [self.palabras count])];
    
    self.hastahora = [@"" stringByPaddingToLength:[self.lapalabra length] withString:@"-" startingAtIndex:0];
    
    
    self.usadas = [[NSMutableString alloc]init];
    self.errores = 0;
    
    
    
}



-(void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ahorcado"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self viewDidLoad]; // Reiniciar el juego
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}



- (IBAction)botonIntento:(id)sender {
    NSString *intento = [self.textfieldIntentos.text lowercaseString];

    if ([intento length] == 0) {
        return;
    }

    char caracterAdivinado = [intento characterAtIndex:0];
    [self.usadas appendString:intento];

    // Actualizar la etiqueta de intentos
    int intentosRestantes = self.maxerror - self.errores;
    self.labelIntentos.text = [NSString stringWithFormat:@"Intentos restantes: %d", intentosRestantes];

    if ([self.lapalabra containsString:intento]) {
        NSMutableString *newhastaahora = [NSMutableString stringWithString:self.hastahora];
        for (int i = 0; i < [self.lapalabra length]; i++) {
            if ([self.lapalabra characterAtIndex:i] == caracterAdivinado) {
                [newhastaahora replaceCharactersInRange:NSMakeRange(i, 1) withString:intento];
            }
        }
        self.hastahora = newhastaahora;
        self.labelProgreso.text = self.hastahora; // Actualiza la etiqueta de progreso

        // Verificar si ganó
        if ([self.hastahora isEqualToString:self.lapalabra]) {
            [self showAlertWithMessage:@"¡GANASTE!"];
            return; // Salir para evitar seguir ejecutando el resto del método
        }
    } else {
        self.errores++;
        // Verificar si perdió
        if (self.errores >= self.maxerror) {
            [self showAlertWithMessage:@"¡PERDISTE!"];
            return; // Salir para evitar seguir ejecutando el resto del método
        }
    }

    self.textfieldIntentos.text = @""; // Limpiar el campo de texto
    intentosRestantes = self.maxerror - self.errores; // Actualizar intentos restantes
    self.labelIntentos.text = [NSString stringWithFormat:@"Intentos restantes: %d", intentosRestantes]; // Actualiza la etiqueta de intentos
}

@end
