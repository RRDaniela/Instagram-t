import 'package:flutter/material.dart';


class Profile extends StatelessWidget {
  
  Profile({
    super.key,
  });
TextStyle myTextStyle = TextStyle(
  fontSize: 15, // Set font size
  fontWeight: FontWeight.bold, // Set font weight
);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF0B3954),
        title: Text('Amlo'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      child: ClipOval(child: Image.asset('assets/images/pejecoin.jpg', fit: BoxFit.cover,),),
                      radius: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        style: myTextStyle,
                        "Amlo"),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      style: myTextStyle,
                      "7"
                    ),
                    Text(
                      style: myTextStyle,
                      "Publicaciones"
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      style: myTextStyle,
                      "1'400,000"),
                    Text(
                      style: myTextStyle,
                      "Seguidores")
                  ],
                ),
                Column(
                  children: [
                    Text(
                      style: myTextStyle,
                      "2"
                    ),
                    Text(
                      style: myTextStyle,
                      "Seguidos"
                    )
                  ],
                )
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
            MaterialButton(
              color: Color(0xFFFF0B3954),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Text(
                "Editar perfil",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: (){}),
              MaterialButton(
              color: Color(0xFFFF0B3954),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Text(
                "Compartir perfil",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: (){}),
              MaterialButton(
              color: Color(0xFFFF0B3954),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Icon(Icons.person_add, color: Colors.white,),
              onPressed: (){})
          ],),
          Text("Historias destacadas",
          style: myTextStyle,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, 
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 7,
                      itemBuilder: (context, index){
                        if(index == 0){
                         return Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
                           child: Column(children: [
                              CircleAvatar(
                                backgroundColor: Color(0xFFFF0B3954),
                                radius: 35,
                                child: Icon(Icons.add),
                              ),
                              Text("Nueva")
                            ],),
                         );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(children: [
                              CircleAvatar(
                                backgroundColor: Color(0xFFFF0B3954),
                                radius: 35,
                              ),
                              Text("nombre")
                            ],),
                          );
                        }
                      },
                      ),
                  ),
                )
            ],
              
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.grid_3x3, color: Color(0xFFFF0B3954),),
              Icon(Icons.portrait, color: Color(0xFFFF0B3954))
          ],),
         
        ]),
    );
  }
}